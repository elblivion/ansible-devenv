export GITHUB_USER={{ lookup('onepassword', 'Github - elblivion', field='username') }}
export GITHUB_PASSWORD={{ lookup('onepassword', 'Github - elblivion', field='password') }}
export GITHUB_TOKEN={{ lookup('onepassword', 'Github https api token', field='password') }}
