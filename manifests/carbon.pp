class windows_services::carbon(
    $carbondll   = "C:\\Carbon.dll",
)
{
    file{"${carbondll}":
        source => "puppet:///modules/windows_services/Carbon.dll",
        source_permissions => ignore,
    }
}
