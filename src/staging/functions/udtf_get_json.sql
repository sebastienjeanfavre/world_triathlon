CREATE OR REPLACE FUNCTION staging.get_json(url VARCHAR, apikey VARCHAR)
RETURNS TABLE (json VARIANT)
LANGUAGE PYTHON
RUNTIME_VERSION = 3.11
HANDLER = 'ApiData'
EXTERNAL_ACCESS_INTEGRATIONS = (world_triathlon_integration)
PACKAGES = ('requests')
AS
$$
import requests
import json
import time

class ApiData:
    def process(self, url, apikey):
        headers = {
            'content-type': "application/json",
            'apikey': apikey
        }
        start_time = time.time()
        response = requests.get(url, headers=headers)
        elapsed_time = time.time() - start_time
        metadata = {
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime()),
            "response_time": elapsed_time,
            "status_code": response.status_code
        }
        if response.status_code == 200 :
            data = response.json()
            # Include _metadata in each item if it's a list or in the data directly
            if isinstance(data, list):
                for item in data:
                    item["_metadata"] = metadata
            else:
                data["_metadata"] = metadata
            yield (json.dumps(data),)
        else:
            yield (json.dumps({"_metadata": metadata}),)
            
$$;
