function New-Diagram {

    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline
        )]
        # [Microsoft.SqlServer.Dac.Model.TSqlModel]
        $DacModel,

        $SchemaSeparator = '-'
    )

    process {
        $lines = @('erDiagram')

        $includedTables = $()

        $DacModel | Get-DacForeignKey | ForEach-Object {
            $sourceTable, $targetTable = $_.GetReferenced() | Where-Object { $_.ObjectType.Name -eq 'Table' }
            $sourceSchemaName, $sourceTableName = $sourceTable.Name.Parts
            $targetSchemaName, $targetTableName = $targetTable.Name.Parts
            $keySchemaName, $keyName = $_.Name.Parts

            $relationString = 'o|--o{'
            $sourceTableString = "$sourceSchemaName$SchemaSeparator$sourceTableName"
            $targetTableString = "$targetSchemaName$SchemaSeparator$targetTableName"

            $lines += "    $sourceTableString $relationString $targetTableString : $keyName"
            $includedTables += $sourceTable, $targetTable | ForEach-Object { $_.Name.ToString() }
        }

        $includedTables = $includedTables | Select-Object -Unique

        $DacModel | Get-DacTable | Where-Object {
            -Not ( $includedTables -contains $_.Name.ToString() )
        } | ForEach-Object {
            $schemaName, $tableName = $_.Name.Parts
            $tableString = "$schemaName$SchemaSeparator$tableName"
            $lines += "    $tableString"
        }

        $lines -join "`r`n" | Write-Output
    }

}
