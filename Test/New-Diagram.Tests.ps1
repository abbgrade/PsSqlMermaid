#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-SqlMermaidDiagram' {

    BeforeDiscovery {
        $Script:PsDockerMermaid = Import-Module PsDockerMermaid -PassThru -ErrorAction Continue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlMermaid.psd1 -Force -ErrorAction Stop
        Import-Module PsDac -ErrorAction Stop
    }

    Context 'wide-world-importers' {

        BeforeDiscovery {
            [System.IO.FileInfo] $Script:WwiDacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
        }

        Context 'DacPac' -Skip:( -Not $Script:WwiDacPacFile.Exists ) {

            BeforeAll {
                $Script:WwiModel = Import-DacModel -Path $Script:WwiDacPacFile
            }

            It 'Creates a diagram' {
                [string] $diagram = $Script:WwiModel | New-SqlMermaidDiagram -ErrorAction Stop

                # $diagram | Out-File 'er.mmd'

                $diagram | Should -BeLike 'erDiagram*'

                $Script:WwiModel | Get-DacTable | ForEach-Object {
                    $schema, $table = $_.Name.Parts
                    $diagram | Should -Match $table
                    $diagram | Should -Not -Match "\[$table\]"
                }
            }

            Context 'Mermaid CLI' -Skip:( -Not $Script:PsDockerMermaid ) {

                It 'Creates a valid diagram' {
                    $svg = $Script:WwiModel | New-SqlMermaidDiagram | Invoke-MermaidCommand

                    # $svg | Out-File 'er.svg'

                    $svg | Should -Not -BeNullOrEmpty
                }
            }

        }

    }

    Context 'multi-project' {

        Context 'sales' {

            BeforeDiscovery {
                [System.IO.FileInfo] $Script:MpsSalesDacPacFile = "$PSScriptRoot\multi-project-sample\sales\bin\Debug\sales.dacpac"
            }

            Context 'DacPac' -Skip:( -Not $Script:MpsSalesDacPacFile.Exists ) {

                BeforeAll {
                    $Script:MpsSalesModel = Import-DacModel -Path $Script:MpsSalesDacPacFile
                }

                It 'Creates a diagram' {
                    [string] $diagram = $Script:MpsSalesModel | New-SqlMermaidDiagram -ErrorAction Stop

                    # $diagram | Out-File 'er.mmd'

                    $diagram | Should -BeLike 'erDiagram*'

                    $Script:MpsSalesModel | Get-DacTable | ForEach-Object {
                        $schema, $table = $_.Name.Parts
                        $diagram | Should -Match $table
                        $diagram | Should -Not -Match "\[$table\]"
                    }
                }

                Context 'Mermaid CLI' -Skip:( -Not $Script:PsDockerMermaid ) {

                    It 'Creates a valid diagram' {
                        $svg = $Script:MpsSalesModel | New-SqlMermaidDiagram | Invoke-MermaidCommand

                        # $svg | Out-File 'er.svg'

                        $svg | Should -Not -BeNullOrEmpty
                    }
                }

            }
        }
    }
}
