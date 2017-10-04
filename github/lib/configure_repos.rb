require "yaml"
require "json"
require "octokit"
require_relative "./configure_repo"

class ConfigureRepos
  def configure!
    repos.each do |repo|
      ConfigureRepo.new(repo, client).configure!
    end
  end

private

  def repos
    client
      .org_repos("alphagov", accept: "application/vnd.github.mercy-preview+json")
      .select { |repo| repo.topics.to_a.include?("govuk") }
      .map(&:full_name)
  end

  def client
    Octokit.auto_paginate = true
    @client ||= Octokit::Client.new(access_token: ENV.fetch("GITHUB_TOKEN"))
  end
end