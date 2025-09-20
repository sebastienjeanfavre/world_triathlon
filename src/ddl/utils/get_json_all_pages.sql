CREATE OR REPLACE FUNCTION staging.get_json_all_pages(url VARCHAR, apikey VARCHAR)
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
        next_page_url = url
        while next_page_url:
            start_time = time.time()
            try:
                response = requests.get(next_page_url, headers=headers)
                elapsed_time = time.time() - start_time
                metadata = {
                    "timestamp": time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime()),
                    "response_time": elapsed_time,
                    "status_code": response.status_code
                }
                if response.status_code == 200:
                    try:
                        data = response.json()
                        # Add metadata and yield each item
                        if isinstance(data, dict) and "data" in data:  # Assuming data key contains items
                            items = data["data"]
                            next_page_url = data.get("next_page_url")  # Fetch the next page URL
                        else:
                            items = data
                            next_page_url = None
                        
                        if isinstance(items, list):
                            for item in items:
                                item["_metadata"] = metadata
                                yield (json.dumps(item),)
                        else:
                            items["_metadata"] = metadata
                            yield (json.dumps(items),)
                    except json.JSONDecodeError:
                        metadata["error"] = "Invalid JSON in response"
                        yield (json.dumps({"_metadata": metadata}),)
                        next_page_url = None
                else:
                    metadata["error"] = response.text
                    yield (json.dumps({"_metadata": metadata}),)
                    next_page_url = None
            except Exception as e:
                elapsed_time = time.time() - start_time
                metadata = {
                    "timestamp": time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime()),
                    "response_time": elapsed_time,
                    "error": str(e)
                }
                yield (json.dumps({"_metadata": metadata}),)
                next_page_url = None
$$;


-- SELECT 
--     f.value
-- FROM TABLE(get_json('https://api.triathlon.org/v1/athletes/' || '106439' || '/results?elite=true', '0201b661afadf43392e4c7dcaed533fe ')) t,
-- LATERAL FLATTEN(input => PARSE_JSON(t.json):data) f
-- ;

-- SELECT 
--     PARSE_JSON(json)
-- FROM TABLE(get_json_all_pages('https://api.triathlon.org/v1/athletes/' || '106439' || '/results?elite=true', '0201b661afadf43392e4c7dcaed533fe '))
-- ;
