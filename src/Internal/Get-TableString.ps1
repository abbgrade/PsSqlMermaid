function Get-TableString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $NameParts,

        [Parameter()]
        $SchemaSeparator = '-'
    )

    $schemaName, $tableName = $NameParts
    Write-Output "$schemaName$SchemaSeparator$tableName"
}
