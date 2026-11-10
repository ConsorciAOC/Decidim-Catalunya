# frozen_string_literal: true

if defined?(Decidim::ReportingProposals)
  Decidim::ReportingProposals.configure do |config|
    config.proposal_answering_follow_up = [:reporting_proposals]
  end
end
