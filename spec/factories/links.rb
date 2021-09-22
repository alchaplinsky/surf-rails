FactoryBot.define do
  factory :link do
    association :submission
    title {'GitHub · How people build software'}
    description {'GitHub is where people build software.'}
    url {'http://github.com'}
    domain {'github.com'}
    image {'https://assets-cdn.github.com/images/modules/open_graph/github-logo.png'}
  end
end
