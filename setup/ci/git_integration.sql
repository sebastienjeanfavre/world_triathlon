USE DATABASE WORLD_TRIATHLON;

-- 2 create git repo obj
CREATE OR REPLACE GIT REPOSITORY governance.git_repo_stage_world_triathlon
  API_INTEGRATION = github_api_integration
  ORIGIN = 'https://github.com/sebastienjeanfavre/world_triathlon.git';

ls @governance.git_repo_stage_world_triathlon/branches/main/;

alter git repository governance.git_repo_stage_world_triathlon fetch;
