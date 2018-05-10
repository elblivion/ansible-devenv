export GITHUB_USER={{ lookup('lastpass', 'github.com - elblivion', field='username') }}
export GITHUB_PASSWORD={{ lookup('lastpass', 'github.com - elblivion', field='token') }}
export GITHUB_TOKEN={{ lookup('lastpass', 'Github https token', field='password') }}
