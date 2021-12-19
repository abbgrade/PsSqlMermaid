function New-Diagram {

    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline
        )]
        # [Microsoft.SqlServer.Dac.Model.TSqlModel]
        $DacModel
    )

    process {
        $lines = @('erDiagram')

        $includedTables = $()

        $DacModel | Get-DacForeignKey | ForEach-Object {
            $sourceTable, $targetTable = $_.GetReferenced() | Where-Object { $_.ObjectType.Name -eq 'Table' }
            $lines += "    $( $sourceTable.Name ) ||--o{ $( $targetTable.Name ) : $( $_.Name )"
            $includedTables += $sourceTable, $targetTable | ForEach-Object { $_.Name.ToString() }
        }

        $includedTables = $includedTables | Select-Object -Unique

        $DacModel | Get-DacTable | Where-Object {
            -Not ( $includedTables -contains $_.Name.ToString() )
        } | ForEach-Object {
            $lines += "    $( $_.Name )"
        }

        $lines -join "`r`n" | Write-Output
    }

}
