from fastapi import FastAPI, HTTPException
import clr  # This is the pythonnet package

app = FastAPI()

# Load the .NET assembly (assuming you copied the .dll to the /app/fhir-anonymizer directory)
clr.AddReference('/app/Microsoft.Health.Fhir.Anonymizer.R4.CommandLineTool.dll')

# Import the necessary classes or namespaces from the .NET assembly
from Microsoft.Health.Fhir.Anonymizer.R4.CommandLineTool import AnonymizerTool  # Adjust this based on actual namespace


@app.post("/anonymize")
async def anonymize(input_dir: str, output_dir: str, config_file: str):
    try:
        # Create an instance of the AnonymizerTool or call a method directly if static
        anonymizer = AnonymizerTool()  # Adjust based on actual usage pattern
        anonymizer.Anonymize(input_dir, output_dir, config_file, verbose=True)  # Example method call

        return {"message": "Anonymization successful"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# A health check endpoint
@app.get("/health")
async def health():
    return {"status": "Healthy"}
