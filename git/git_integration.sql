-- 1 Create API integration
CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/sebastienjeanfavre')
  ENABLED = TRUE;

desc integration git_api_integration;

-- 2 create git repo obj
CREATE OR REPLACE GIT REPOSITORY git_repo_stage_world_triathlon
  API_INTEGRATION = git_api_integration
  ORIGIN = 'https://github.com/sebastienjeanfavre/world_triathlon.git';

ls @git_repo_stage_world_triathlon/branches/main/;