function New-Diagram {

    <#

    .SYNOPSIS
    Creates an ER diagram for a Dac model.

    .DESCRIPTION
    Uses PsDac to select the tables and foreign key constrains from a database model and creates a mermaid Entity Relationship diagrams.

    .EXAMPLE

    PS C:\> Import-DacModel WideWorldImporters.dacpac | New-SqlMermaidDiagram

    <svg id="mermaid-1639919827409" width="100%" xmlns="http://www.w3.org/2000/svg" ...

    #>

    [CmdletBinding()]
    param (

        # Specifies the database model.
        [Parameter(
            ValueFromPipeline
        )]
        # [Microsoft.SqlServer.Dac.Model.TSqlModel]
        $DacModel,

        # Specifies the separator between schema and table name.
        [Parameter()]
        $SchemaSeparator = '-'
    )

    process {
        $lines = @('erDiagram')

        $includedTables = $()

        $DacModel | Get-DacForeignKey | ForEach-Object {
            $sourceTable, $targetTable = $_.GetReferenced() | Where-Object { $_.ObjectType.Name -eq 'Table' }

            if ( $targetTable ) {
                $sourceSchemaName, $sourceTableName = $sourceTable.Name.Parts
                $targetSchemaName, $targetTableName = $targetTable.Name.Parts
                $keySchemaName, $keyName = $_.Name.Parts

                $relationString = 'o|--o{'
                $sourceTableString = "$sourceSchemaName$SchemaSeparator$sourceTableName"
                $targetTableString = "$targetSchemaName$SchemaSeparator$targetTableName"

                $lines += "    $sourceTableString $relationString $targetTableString : $keyName"
                $includedTables += $sourceTable, $targetTable | ForEach-Object { $_.Name.ToString() }
            } else {
                Write-Verbose "Exclude $( $_.Name ). Foreign table was not found."
            }
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
