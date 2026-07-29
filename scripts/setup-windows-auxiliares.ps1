#requires -Version 7.4
#requires -RunAsAdministrator

<#
.SYNOPSIS
    Instala ferramentas acadêmicas auxiliares no Windows.

.DESCRIPTION
    Configura componentes que não são instalados integralmente pelo
    setup-windows.ps1:

    - Apache Maven.
    - vcpkg.
    - JFLAP.

    O script não instala jogos, drivers, credenciais ou senhas.

.PARAMETER IgnorarMaven
    Não instala nem configura o Apache Maven.

.PARAMETER IgnorarVcpkg
    Não instala nem configura o vcpkg.

.PARAMETER IgnorarJFLAP
    Não instala nem configura o JFLAP.

.PARAMETER CaminhoJFLAPJar
    Caminho opcional para uma cópia local do JFLAP7.1.jar.
    É útil caso o servidor oficial bloqueie o download automatizado.
#>

[CmdletBinding()]
param(
    [switch] $IgnorarMaven,
    [switch] $IgnorarVcpkg,
    [switch] $IgnorarJFLAP,

    [string] $CaminhoJFLAPJar
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$MavenVersion = "3.9.16"

$MavenParent = Join-Path `
    $HOME `
    "Tools"

$MavenRoot = Join-Path `
    $MavenParent `
    "apache-maven-$MavenVersion"

$VcpkgRoot = "C:\Tools\vcpkg"
$JFLAPRoot = "C:\Tools\JFLAP"

$PastaLogs = Join-Path `
    $env:ProgramData `
    "FaculdadeBCC\Logs"

New-Item `
    -ItemType Directory `
    -Path $PastaLogs `
    -Force |
    Out-Null

$DataLog = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$ArquivoLog = Join-Path `
    $PastaLogs `
    "setup-windows-auxiliares-$DataLog.log"

Start-Transcript `
    -LiteralPath $ArquivoLog `
    -Force |
    Out-Null

$Resultados = [System.Collections.Generic.List[object]]::new()

function Adicionar-Resultado {
    param(
        [Parameter(Mandatory)]
        [string] $Ferramenta,

        [Parameter(Mandatory)]
        [string] $Resultado
    )

    $Resultados.Add(
        [PSCustomObject]@{
            Ferramenta = $Ferramenta
            Resultado  = $Resultado
        }
    )
}

function Testar-Comando {
    param(
        [Parameter(Mandatory)]
        [string] $Nome
    )

    return $null -ne (
        Get-Command `
            $Nome `
            -ErrorAction SilentlyContinue
    )
}

function Adicionar-PathUsuario {
    param(
        [Parameter(Mandatory)]
        [string] $Diretorio
    )

    $DiretorioNormalizado = (
        [System.IO.Path]::GetFullPath($Diretorio)
    ).TrimEnd("\")

    $PathUsuario = [Environment]::GetEnvironmentVariable(
        "Path",
        "User"
    )

    $EntradasUsuario = @()

    if (-not [string]::IsNullOrWhiteSpace($PathUsuario)) {
        $EntradasUsuario = @(
            $PathUsuario -split ";" |
                Where-Object {
                    -not [string]::IsNullOrWhiteSpace($_)
                }
        )
    }

    $JaExiste = @(
        $EntradasUsuario |
            Where-Object {
                $_.TrimEnd("\") -ieq $DiretorioNormalizado
            }
    ).Count -gt 0

    if (-not $JaExiste) {
        $NovoPath = @(
            $EntradasUsuario
            $DiretorioNormalizado
        ) -join ";"

        [Environment]::SetEnvironmentVariable(
            "Path",
            $NovoPath,
            "User"
        )

        Write-Host "Adicionado ao PATH do usuário: $Diretorio"
    }
    else {
        Write-Host "Diretório já está no PATH: $Diretorio"
    }

    $EntradasProcesso = @(
        $env:Path -split ";" |
            Where-Object {
                -not [string]::IsNullOrWhiteSpace($_)
            }
    )

    $ExisteNoProcesso = @(
        $EntradasProcesso |
            Where-Object {
                $_.TrimEnd("\") -ieq $DiretorioNormalizado
            }
    ).Count -gt 0

    if (-not $ExisteNoProcesso) {
        $env:Path = "$DiretorioNormalizado;$env:Path"
    }
}

function Baixar-Arquivo {
    param(
        [Parameter(Mandatory)]
        [uri] $Uri,

        [Parameter(Mandatory)]
        [string] $Destino
    )

    Write-Host "Baixando: $Uri"

    Invoke-WebRequest `
        -Uri $Uri `
        -OutFile $Destino `
        -MaximumRetryCount 3 `
        -RetryIntervalSec 3
}

function Instalar-Maven {
    Write-Host "`n=== APACHE MAVEN ==="

    if (-not (Testar-Comando -Nome "java")) {
        throw (
            "Java não foi encontrado. Execute primeiro " +
            "o setup-windows.ps1."
        )
    }

    New-Item `
        -ItemType Directory `
        -Path $MavenParent `
        -Force |
        Out-Null

    $ExecutavelMaven = Join-Path `
        $MavenRoot `
        "bin\mvn.cmd"

    if (-not (Test-Path -LiteralPath $ExecutavelMaven)) {
        if (Test-Path -LiteralPath $MavenRoot) {
            Write-Warning (
                "Instalação incompleta do Maven encontrada. " +
                "O diretório será recriado."
            )

            Remove-Item `
                -LiteralPath $MavenRoot `
                -Recurse `
                -Force
        }

        $Temporario = Join-Path `
            ([System.IO.Path]::GetTempPath()) `
            (
                "faculdade-maven-" +
                [guid]::NewGuid().ToString("N")
            )

        New-Item `
            -ItemType Directory `
            -Path $Temporario `
            -Force |
            Out-Null

        try {
            $ArquivoZip = Join-Path `
                $Temporario `
                "apache-maven-$MavenVersion-bin.zip"

            $ArquivoSha512 = "$ArquivoZip.sha512"

            $BaseDownload = (
                "https://dlcdn.apache.org/maven/" +
                "maven-3/$MavenVersion/binaries"
            )

            $BaseChecksum = (
                "https://downloads.apache.org/maven/" +
                "maven-3/$MavenVersion/binaries"
            )

            Baixar-Arquivo `
                -Uri (
                    "$BaseDownload/" +
                    "apache-maven-$MavenVersion-bin.zip"
                ) `
                -Destino $ArquivoZip

            Baixar-Arquivo `
                -Uri (
                    "$BaseChecksum/" +
                    "apache-maven-$MavenVersion-bin.zip.sha512"
                ) `
                -Destino $ArquivoSha512

            $TextoChecksum = Get-Content `
                -LiteralPath $ArquivoSha512 `
                -Raw

            $Correspondencia = [regex]::Match(
                $TextoChecksum,
                "[0-9A-Fa-f]{128}"
            )

            if (-not $Correspondencia.Success) {
                throw "Checksum SHA-512 oficial inválido."
            }

            $HashEsperado = (
                $Correspondencia.Value
            ).ToUpperInvariant()

            $HashObtido = (
                Get-FileHash `
                    -LiteralPath $ArquivoZip `
                    -Algorithm SHA512
            ).Hash.ToUpperInvariant()

            if ($HashObtido -ne $HashEsperado) {
                throw (
                    "O checksum do Apache Maven não confere. " +
                    "O arquivo não será instalado."
                )
            }

            Write-Host "Checksum SHA-512 do Maven: OK"

            $PastaExtracao = Join-Path `
                $Temporario `
                "extraido"

            Expand-Archive `
                -LiteralPath $ArquivoZip `
                -DestinationPath $PastaExtracao `
                -Force

            $OrigemExtraida = Join-Path `
                $PastaExtracao `
                "apache-maven-$MavenVersion"

            if (-not (Test-Path -LiteralPath $OrigemExtraida)) {
                throw "Diretório extraído do Maven não encontrado."
            }

            Move-Item `
                -LiteralPath $OrigemExtraida `
                -Destination $MavenRoot
        }
        finally {
            if (Test-Path -LiteralPath $Temporario) {
                Remove-Item `
                    -LiteralPath $Temporario `
                    -Recurse `
                    -Force
            }
        }
    }
    else {
        Write-Host "Maven já instalado em: $MavenRoot"
    }

    [Environment]::SetEnvironmentVariable(
        "MAVEN_HOME",
        $MavenRoot,
        "User"
    )

    $env:MAVEN_HOME = $MavenRoot

    $MavenBin = Join-Path `
        $MavenRoot `
        "bin"

    Adicionar-PathUsuario `
        -Diretorio $MavenBin

    & $ExecutavelMaven -version

    if ($LASTEXITCODE -ne 0) {
        throw "O Maven foi instalado, mas a validação falhou."
    }

    Adicionar-Resultado `
        -Ferramenta "Apache Maven $MavenVersion" `
        -Resultado "Configurado"
}

function Instalar-Vcpkg {
    Write-Host "`n=== VCPKG ==="

    if (-not (Testar-Comando -Nome "git")) {
        throw (
            "Git não foi encontrado. Execute primeiro " +
            "o setup-windows.ps1."
        )
    }

    $PastaTools = Split-Path `
        -Path $VcpkgRoot `
        -Parent

    New-Item `
        -ItemType Directory `
        -Path $PastaTools `
        -Force |
        Out-Null

    if (-not (Test-Path -LiteralPath $VcpkgRoot)) {
        & git clone `
            "https://github.com/microsoft/vcpkg.git" `
            $VcpkgRoot

        if ($LASTEXITCODE -ne 0) {
            throw "Falha ao clonar o repositório do vcpkg."
        }
    }
    elseif (
        -not (
            Test-Path `
                -LiteralPath (
                    Join-Path $VcpkgRoot ".git"
                )
        )
    ) {
        throw (
            "O diretório C:\Tools\vcpkg existe, mas não " +
            "é uma cópia válida do repositório vcpkg."
        )
    }
    else {
        $Alteracoes = & git `
            -C $VcpkgRoot `
            status `
            --porcelain

        if ([string]::IsNullOrWhiteSpace(
            ($Alteracoes -join "`n")
        )) {
            & git `
                -C $VcpkgRoot `
                pull `
                --ff-only

            if ($LASTEXITCODE -ne 0) {
                throw "Falha ao atualizar o vcpkg."
            }
        }
        else {
            Write-Warning (
                "O vcpkg possui alterações locais. " +
                "A atualização foi ignorada."
            )
        }
    }

    $Bootstrap = Join-Path `
        $VcpkgRoot `
        "bootstrap-vcpkg.bat"

    & $Bootstrap

    if ($LASTEXITCODE -ne 0) {
        throw "Falha no bootstrap do vcpkg."
    }

    $ExecutavelVcpkg = Join-Path `
        $VcpkgRoot `
        "vcpkg.exe"

    if (-not (Test-Path -LiteralPath $ExecutavelVcpkg)) {
        throw "O executável vcpkg.exe não foi criado."
    }

    [Environment]::SetEnvironmentVariable(
        "VCPKG_ROOT",
        $VcpkgRoot,
        "User"
    )

    $env:VCPKG_ROOT = $VcpkgRoot

    Adicionar-PathUsuario `
        -Diretorio $VcpkgRoot

    & $ExecutavelVcpkg version

    if ($LASTEXITCODE -ne 0) {
        throw "A validação do vcpkg falhou."
    }

    & $ExecutavelVcpkg integrate install

    if ($LASTEXITCODE -ne 0) {
        Write-Warning (
            "O vcpkg foi instalado, mas a integração " +
            "global com MSBuild não foi concluída."
        )
    }

    Adicionar-Resultado `
        -Ferramenta "vcpkg" `
        -Resultado "Configurado"
}

function Resolver-Javaw {
    $Candidatos = [System.Collections.Generic.List[string]]::new()

    if (-not [string]::IsNullOrWhiteSpace($env:JAVA_HOME)) {
        $Candidatos.Add(
            (
                Join-Path `
                    $env:JAVA_HOME `
                    "bin\javaw.exe"
            )
        )
    }

    $ComandoJavaw = Get-Command `
        javaw.exe `
        -ErrorAction SilentlyContinue

    if ($null -ne $ComandoJavaw) {
        $Candidatos.Add($ComandoJavaw.Source)
    }

    foreach ($Candidato in $Candidatos) {
        if (Test-Path -LiteralPath $Candidato) {
            return $Candidato
        }
    }

    return $null
}

function Instalar-JFLAP {
    Write-Host "`n=== JFLAP 7.1 ==="

    $Javaw = Resolver-Javaw

    if ($null -eq $Javaw) {
        throw (
            "javaw.exe não foi encontrado. Instale o " +
            "Eclipse Temurin JDK 21 antes do JFLAP."
        )
    }

    New-Item `
        -ItemType Directory `
        -Path $JFLAPRoot `
        -Force |
        Out-Null

    $DestinoJFLAP = Join-Path `
        $JFLAPRoot `
        "JFLAP7.1.jar"

    if (-not (Test-Path -LiteralPath $DestinoJFLAP)) {
        if (
            -not [string]::IsNullOrWhiteSpace(
                $CaminhoJFLAPJar
            )
        ) {
            if (-not (
                Test-Path `
                    -LiteralPath $CaminhoJFLAPJar
            )) {
                throw (
                    "Arquivo JFLAP informado não encontrado: " +
                    $CaminhoJFLAPJar
                )
            }

            Copy-Item `
                -LiteralPath $CaminhoJFLAPJar `
                -Destination $DestinoJFLAP `
                -Force
        }
        else {
            $PaginaJFLAP = [uri](
                "https://www.jflap.org/jflaptmp/"
            )

            try {
                $Resposta = Invoke-WebRequest `
                    -Uri $PaginaJFLAP `
                    -MaximumRetryCount 2 `
                    -RetryIntervalSec 3

                $LinkJFLAP = $Resposta.Links |
                    Where-Object {
                        $_.href -match "JFLAP7[.]1[.]jar"
                    } |
                    Select-Object -First 1

                if ($null -eq $LinkJFLAP) {
                    throw (
                        "O link do JFLAP7.1.jar não foi " +
                        "encontrado na página oficial."
                    )
                }

                $UriJFLAP = [uri]::new(
                    $PaginaJFLAP,
                    $LinkJFLAP.href
                )

                Baixar-Arquivo `
                    -Uri $UriJFLAP `
                    -Destino $DestinoJFLAP
            }
            catch {
                throw @"
Não foi possível baixar automaticamente o JFLAP.

Baixe manualmente o JFLAP7.1.jar no site oficial e execute:

.\setup-windows-auxiliares.ps1 `
    -IgnorarMaven `
    -IgnorarVcpkg `
    -CaminhoJFLAPJar "C:\caminho\JFLAP7.1.jar"

Erro original: $($_.Exception.Message)
"@
            }
        }
    }
    else {
        Write-Host "JFLAP já existe em: $DestinoJFLAP"
    }

    Add-Type `
        -AssemblyName System.IO.Compression.FileSystem

    $JarAberto = [System.IO.Compression.ZipFile]::OpenRead(
        $DestinoJFLAP
    )

    try {
        $Manifesto = $JarAberto.Entries |
            Where-Object {
                $_.FullName -eq "META-INF/MANIFEST.MF"
            } |
            Select-Object -First 1

        if ($null -eq $Manifesto) {
            throw (
                "O arquivo informado não parece ser " +
                "um JAR válido do JFLAP."
            )
        }
    }
    finally {
        $JarAberto.Dispose()
    }

    $PastaMenuIniciar = Join-Path `
        $env:APPDATA `
        "Microsoft\Windows\Start Menu\Programs"

    $Atalho = Join-Path `
        $PastaMenuIniciar `
        "JFLAP 7.1.lnk"

    $Shell = New-Object `
        -ComObject WScript.Shell

    $Link = $Shell.CreateShortcut($Atalho)
    $Link.TargetPath = $Javaw
    $Link.Arguments = "-jar `"$DestinoJFLAP`""
    $Link.WorkingDirectory = $JFLAPRoot
    $Link.Description = (
        "JFLAP 7.1 - Linguagens Formais e Autômatos"
    )
    $Link.Save()

    Write-Host "Atalho criado no Menu Iniciar."
    Write-Host "JFLAP instalado em: $DestinoJFLAP"

    Adicionar-Resultado `
        -Ferramenta "JFLAP 7.1" `
        -Resultado "Configurado"
}

try {
    if (-not $IgnorarMaven) {
        Instalar-Maven
    }

    if (-not $IgnorarVcpkg) {
        Instalar-Vcpkg
    }

    if (-not $IgnorarJFLAP) {
        Instalar-JFLAP
    }

    Write-Host "`n=== RESULTADO FINAL ==="

    $Resultados |
        Format-Table -AutoSize

    $ArquivoResultado = Join-Path `
        $PastaLogs `
        "setup-windows-auxiliares-$DataLog.csv"

    $Resultados |
        Export-Csv `
            -LiteralPath $ArquivoResultado `
            -NoTypeInformation `
            -Encoding utf8

    Write-Host "`nRelatório: $ArquivoResultado"

    Write-Host @"

Ferramentas auxiliares configuradas.

Pode ser necessário fechar e abrir novamente o terminal para que
MAVEN_HOME, VCPKG_ROOT e as alterações do PATH sejam reconhecidas
por todos os programas.
"@
}
finally {
    Stop-Transcript |
        Out-Null
}
