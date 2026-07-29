#requires -Version 7.4
#requires -RunAsAdministrator

<#
.SYNOPSIS
    Instala o ambiente acadêmico principal no Windows.

.DESCRIPTION
    Instala programas usados no curso de Ciência da Computação por meio
    do WinGet. O script não instala jogos, launchers, personalizações,
    drivers nem credenciais.

    O script pode ser executado novamente. Pacotes já instalados serão
    identificados e ignorados.

.NOTES
    As chaves SSH, autenticação do GitHub, Maven manual, vcpkg, JFLAP e
    configurações internas dos programas são tratados em etapas separadas.
#>

[CmdletBinding()]
param(
    [switch] $IgnorarVisualStudio,
    [switch] $IgnorarWSL,
    [switch] $IgnorarExtensoesVSCode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

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
    "setup-windows-$DataLog.log"

Start-Transcript `
    -LiteralPath $ArquivoLog `
    -Force |
    Out-Null

$Resultados = [System.Collections.Generic.List[object]]::new()

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

function Resolver-CodeCLI {
    $Comando = Get-Command `
        code.cmd `
        -ErrorAction SilentlyContinue

    if ($null -eq $Comando) {
        $Comando = Get-Command `
            code `
            -ErrorAction SilentlyContinue
    }

    if ($null -ne $Comando) {
        return $Comando.Source
    }

    $Candidatos = @(
        (
            Join-Path `
                $env:LOCALAPPDATA `
                "Programs\Microsoft VS Code\bin\code.cmd"
        ),
        (
            Join-Path `
                $env:ProgramFiles `
                "Microsoft VS Code\bin\code.cmd"
        ),
        (
            Join-Path `
                ${env:ProgramFiles(x86)} `
                "Microsoft VS Code\bin\code.cmd"
        )
    )

    foreach ($Candidato in $Candidatos) {
        if (Test-Path -LiteralPath $Candidato) {
            return $Candidato
        }
    }

    return $null
}

function Testar-PacoteInstalado {
    param(
        [Parameter(Mandatory)]
        [string] $Id
    )

    & winget list `
        --id $Id `
        --exact `
        --accept-source-agreements `
        *> $null

    return $LASTEXITCODE -eq 0
}

function Instalar-PacoteWinget {
    param(
        [Parameter(Mandatory)]
        [string] $Nome,

        [Parameter(Mandatory)]
        [string] $Id,

        [string] $Fonte = "winget",

        [string] $Override
    )

    Write-Host "`n=== $Nome ==="

    if (Testar-PacoteInstalado -Id $Id) {
        Write-Host "Já instalado: $Id"

        $Resultados.Add(
            [PSCustomObject]@{
                Nome      = $Nome
                Id        = $Id
                Resultado = "Já instalado"
            }
        )

        return
    }

    & winget show `
        --id $Id `
        --exact `
        --source $Fonte `
        --accept-source-agreements `
        *> $null

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Pacote não encontrado: $Id"

        $Resultados.Add(
            [PSCustomObject]@{
                Nome      = $Nome
                Id        = $Id
                Resultado = "Não encontrado"
            }
        )

        return
    }

    $Argumentos = @(
        "install",
        "--id", $Id,
        "--exact",
        "--source", $Fonte,
        "--accept-source-agreements",
        "--accept-package-agreements"
    )

    if (-not [string]::IsNullOrWhiteSpace($Override)) {
        $Argumentos += @(
            "--override",
            $Override
        )
    }

    & winget @Argumentos

    if ($LASTEXITCODE -eq 0) {
        $Resultado = "Instalado"
        Write-Host "Instalação concluída: $Id"
    }
    else {
        $Resultado = "Falhou: código $LASTEXITCODE"
        Write-Warning "Falha na instalação de $Id"
    }

    $Resultados.Add(
        [PSCustomObject]@{
            Nome      = $Nome
            Id        = $Id
            Resultado = $Resultado
        }
    )
}

try {
    if (-not (Testar-Comando -Nome "winget")) {
        throw (
            "WinGet não encontrado. Instale ou atualize " +
            "o Instalador de Aplicativo da Microsoft."
        )
    }

    winget source update

    $Pacotes = @(
        @{
            Nome = "7-Zip"
            Id   = "7zip.7zip"
        },
        @{
            Nome = "Blender"
            Id   = "BlenderFoundation.Blender"
        },
        @{
            Nome = "DBeaver Community"
            Id   = "DBeaver.DBeaver.Community"
        },
        @{
            Nome = "Zotero"
            Id   = "DigitalScholar.Zotero"
        },
        @{
            Nome = "Docker Desktop"
            Id   = "Docker.DockerDesktop"
        },
        @{
            Nome = "Eclipse Temurin JDK 21"
            Id   = "EclipseAdoptium.Temurin.21.JDK"
        },
        @{
            Nome = "PDF24 Creator"
            Id   = "geeksoftwareGmbH.PDF24Creator"
        },
        @{
            Nome = "Git"
            Id   = "Git.Git"
        },
        @{
            Nome = "GitHub CLI"
            Id   = "GitHub.cli"
        },
        @{
            Nome = "JetBrains Toolbox"
            Id   = "JetBrains.Toolbox"
        },
        @{
            Nome = "Mozilla Firefox"
            Id   = "Mozilla.Firefox"
        },
        @{
            Nome = "PowerShell 7"
            Id   = "Microsoft.PowerShell"
        },
        @{
            Nome = "Visual Studio Code"
            Id   = "Microsoft.VisualStudioCode"
        },
        @{
            Nome = "Windows Terminal"
            Id   = "Microsoft.WindowsTerminal"
        },
        @{
            Nome = "LibreOffice"
            Id   = "TheDocumentFoundation.LibreOffice"
        }
    )

    foreach ($Pacote in $Pacotes) {
        Instalar-PacoteWinget `
            -Nome $Pacote.Nome `
            -Id $Pacote.Id
    }

    if (-not $IgnorarVisualStudio) {
        Instalar-PacoteWinget `
            -Nome "Visual Studio Community" `
            -Id "Microsoft.VisualStudio.Community" `
            -Override (
                "--wait --passive --norestart " +
                "--add Microsoft.VisualStudio.Workload.NativeDesktop " +
                "--includeRecommended"
            )
    }

    if (-not $IgnorarWSL) {
        Instalar-PacoteWinget `
            -Nome "Windows Subsystem for Linux" `
            -Id "Microsoft.WSL"
    }

    if (-not $IgnorarExtensoesVSCode) {
        $CodeCLI = Resolver-CodeCLI

        if ($null -eq $CodeCLI) {
            Write-Warning (
                "VS Code CLI não encontrado. As extensões " +
                "deverão ser instaladas após reiniciar o terminal."
            )
        }
        else {
        $Extensoes = @(
            "aaron-bond.better-comments",
            "alefragnani.bookmarks",
            "catppuccin.catppuccin-vsc",
            "catppuccin.catppuccin-vsc-icons",
            "editorconfig.editorconfig",
            "esbenp.prettier-vscode",
            "formulahendry.auto-rename-tag",
            "github.vscode-pull-request-github",
            "mechatroner.rainbow-csv",
            "ms-azuretools.vscode-containers",
            "ms-vscode-remote.remote-containers",
            "ms-vscode-remote.remote-wsl",
            "ms-vscode.cmake-tools",
            "ms-vscode.cpp-devtools",
            "ms-vscode.cpptools",
            "ms-vscode.cpptools-extension-pack",
            "ms-vscode.cpptools-themes",
            "redhat.java",
            "redhat.vscode-yaml",
            "streetsidesoftware.code-spell-checker",
            "streetsidesoftware.code-spell-checker-portuguese-brazilian",
            "tomoki1207.pdf",
            "usernamehw.errorlens",
            "vscjava.vscode-gradle",
            "vscjava.vscode-java-debug",
            "vscjava.vscode-java-dependency",
            "vscjava.vscode-java-pack",
            "vscjava.vscode-java-test",
            "vscjava.vscode-maven"
        )

        foreach ($Extensao in $Extensoes) {
            Write-Host "Instalando extensão: $Extensao"

            & $CodeCLI `
                --install-extension $Extensao `
                --force
        }
        }
    }

    Write-Host "`n=== RESULTADO FINAL ==="

    $Resultados |
        Format-Table -AutoSize

    $ArquivoResultado = Join-Path `
        $PastaLogs `
        "setup-windows-$DataLog.csv"

    $Resultados |
        Export-Csv `
            -LiteralPath $ArquivoResultado `
            -NoTypeInformation `
            -Encoding utf8

    Write-Host "`nRelatório: $ArquivoResultado"

    Write-Host @"

Próximas ações após uma instalação nova:

1. Reinicie o Windows.
2. Execute:
   wsl --install -d Ubuntu-24.04 --no-launch
3. Abra o Ubuntu e crie o usuário Linux.
4. Execute o script setup-wsl.sh.
5. Recrie as chaves SSH e autentique o GitHub CLI.
6. Configure Docker Desktop e sua integração com o WSL.
"@
}
finally {
    Stop-Transcript |
        Out-Null
}
