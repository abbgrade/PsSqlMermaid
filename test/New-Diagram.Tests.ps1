#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

[CmdletBinding()]
param (
    [System.IO.FileInfo] $WwiDacPacFile = "$PsScriptRoot/sql-server-samples/samples/databases/wide-world-importers/wwi-ssdt/wwi-ssdt/bin/Debug/WideWorldImporters.dacpac",
    [System.IO.FileInfo] $MpsSalesDacPacFile = "$PSScriptRoot/multi-project-sample/sales/bin/Debug/sales.dacpac"
)

Describe New-Diagram {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlMermaid.psd1 -Force -ErrorAction Stop
    }

    Context wide-world-importers {

        Context DacPac -Skip:( -Not $WwiDacPacFile.Exists ) {

            BeforeAll {
                $WwiModel = Import-DacModel -Path $WwiDacPacFile
            }

            It Creates-a-diagram {
                [string] $diagram = $WwiModel | New-SqlMermaidDiagram -ErrorAction Stop

                # $diagram | Out-File 'wwi-er.mmd'

                $diagram | Should -BeLike 'erDiagram*'

                $WwiModel | Get-DacTable | ForEach-Object {
                    $schema, $table = $_.Name.Parts
                    $diagram | Should -Match $table
                    $diagram | Should -Not -Match "\[$table\]"
                }
            }

            Context Mermaid-CLI -Skip:( -Not $PsDockerMermaid ) {

                It Creates-a-valid-diagram {
                    $svg = $WwiModel | New-SqlMermaidDiagram | Invoke-MermaidCommand

                    # $svg | Out-File 'er.svg'

                    $svg | Should -Not -BeNullOrEmpty
                }
            }

        }

    }

    Context multi-project {

        Context sales {

            Context DacPac -Skip:( -Not $MpsSalesDacPacFile.Exists ) {

                BeforeAll {
                    $MpsSalesModel = Import-DacModel -Path $MpsSalesDacPacFile
                }

                It Creates-a-diagram {
                    [string] $diagram = $MpsSalesModel | New-SqlMermaidDiagram -ErrorAction Stop

                    # $diagram | Out-File 'mp-er.mmd'

                    $diagram | Should -BeLike 'erDiagram*'

                    $MpsSalesModel | Get-DacTable | ForEach-Object {
                        $schema, $table = $_.Name.Parts
                        $diagram | Should -Match $table
                        $diagram | Should -Not -Match "\[$table\]"
                    }
                }

                Context Mermaid-CLI -Skip:( -Not $PsDockerMermaid ) {

                    It 'Creates a valid diagram' {
                        $svg = $MpsSalesModel | New-SqlMermaidDiagram | Invoke-MermaidCommand

                        # $svg | Out-File 'er.svg'

                        $svg | Should -Not -BeNullOrEmpty
                    }
                }

            }
        }
    }
}
