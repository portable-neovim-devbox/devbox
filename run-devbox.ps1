Param(
    [string]$Path
)

$strRet = docker volume ls -q

if ($strRet -notcontains "devbox_devbox-data" -or
    $strRet -notcontains "devbox_nvim-plugin-cache" -or
    $strRet -notcontains "devbox_root-dotssh" -or
    $strRet -notcontains "devbox_root-nvim-plugin" -or
    $strRet -notcontains "devbox_user-dotssh" -or
    $strRet -notcontains "devbox_user-nvim-plugin") {

    Write-Host "Required docker volumes doesn't exist. Creating..." -ForegroundColor Yellow
    Set-Location '${DEVBOX_PATH}'
    docker compose create devbox-storage

}

$strRet = docker volume ls -q

if ($strRet -notcontains "devbox_devbox-data" -or
    $strRet -notcontains "devbox_nvim-plugin-cache" -or
    $strRet -notcontains "devbox_root-dotssh" -or
    $strRet -notcontains "devbox_root-nvim-plugin" -or
    $strRet -notcontains "devbox_user-dotssh" -or
    $strRet -notcontains "devbox_user-nvim-plugin") {

    Write-Host "Error: Failed to create Docker volumes. " -ForegroundColor Red
    exit -1

}

docker run --rm -it `
    -e LANG=en_US.UTF-8 `
    --volumes-from devbox-storage-master `
    -v "${Path}:/home/user/project" `
    devbox:latest
