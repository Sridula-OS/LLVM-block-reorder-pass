$ErrorActionPreference = "Stop"

$image = "llvm-block-reorder-pass:llvm14"
$workspace = (Resolve-Path $PSScriptRoot).Path

Push-Location $workspace
try {
    docker build -t $image .
    docker run --rm `
        --mount "type=bind,source=$workspace,target=/workspace" `
        $image
}
finally {
    Pop-Location
}
