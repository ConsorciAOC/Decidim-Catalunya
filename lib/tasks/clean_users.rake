# frozen_string_literal: true

#
# A task set to clean up users from DB.
#
namespace :clean_users do
  desc "Removes users that have registered with email and password."
  task :participants, [:org_id, :must_remove] => :environment do |_task, args|
    organization = Decidim::Organization.find(args.org_id)
    remove= args.must_remove == "true"
    participants = organization.users.where(admin: false)

    puts "Participants for organization #{organization.name}: #{participants.count}"
    puts "----------------------------------------"
    # exclude participants that have a Decidim::Identity with provider 'valid'
    participants_wo_valid = participants.where.not(id: Decidim::Identity.where(provider: "valid").pluck(:decidim_user_id))
    puts "Participants signed up with email: #{participants_wo_valid.count}"

    if remove
      participants_wo_valid.each do |participant|
        puts "#{participant.id},\"#{participant.name}\",#{participant.email}"
      end
    end
  end
end
