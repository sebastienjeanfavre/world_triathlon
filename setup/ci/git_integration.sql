-- 1 Create API integration
CREATE OR REPLACE API INTEGRATION apii_git_world_triathlon
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/sebastienjeanfavre')
  API_USER_AUTHENTICATION = (TYPE = SNOWFLAKE_GITHUB_APP)
  ENABLED = TRUE;

desc integration apii_git_world_triathlon;

-- 2 create git repo obj
CREATE OR REPLACE GIT REPOSITORY orchestration.git_repo_stage_world_triathlon
  API_INTEGRATION = apii_git_world_triathlon
  ORIGIN = 'https://github.com/sebastienjeanfavre/world_triathlon.git';

ls @orchestration.git_repo_stage_world_triathlon/branches/main/;

alter git repository orchestration.git_repo_stage_world_triathlon fetch;