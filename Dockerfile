# Set the base image as the .NET 6.0 SDK (this includes the runtime)
FROM mcr.microsoft.com/dotnet/sdk:6.0 as base

# Copy everything and publish the release (publish implicitly restores and builds)
COPY . ./
RUN dotnet publish ./NET6.WebAPI/NET6.WebAPI.csproj -c Release -o out --no-self-contained

# Label the container
LABEL maintainer="Nhat Thai <thaiquangnhatit@gmail.com>"

# Relayer the .NET SDK, anew with the build output
FROM mcr.microsoft.com/dotnet/sdk:6.0
COPY --from=build-env /out .
ENTRYPOINT [ "dotnet", "/NET6.WebAPI.dll" ]
