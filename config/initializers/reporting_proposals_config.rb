# frozen_string_literal: true

Decidim::ReportingProposals.configure do |config|
  config.proposal_answering_follow_up = [:reporting_proposals]
end
