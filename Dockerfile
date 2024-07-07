FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copy the project files
COPY . .

# Build the project
RUN dotnet build FHIR/src/Microsoft.Health.Fhir.Anonymizer.R4.CommandLineTool -c Release

FROM mcr.microsoft.com/dotnet/runtime:6.0
WORKDIR /app
COPY --from=build /app/FHIR/src/Microsoft.Health.Fhir.Anonymizer.R4.CommandLineTool/bin/Release/net6.0 /app

ENTRYPOINT ["dotnet", "Microsoft.Health.Fhir.Anonymizer.R4.CommandLineTool.dll"]
