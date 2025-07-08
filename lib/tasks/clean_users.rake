# frozen_string_literal: true

#
# A task set to clean up users from DB.
#
namespace :clean_users do
  desc "Removes users that have registered with email and password."
  task :participants, [:org_id, :action] => :environment do |_task, args|
    organization = Decidim::Organization.find(args.org_id)
    participants = organization.users.where(admin: false)

    puts "Participants for organization #{organization.name}: #{participants.count}"
    puts "----------------------------------------"
    # exclude participants that have a Decidim::Identity with provider 'valid'
    participants_wo_valid = participants.where.not(id: Decidim::Identity.where(provider: "valid").pluck(:decidim_user_id))
    # exclude participants that have a Decidim::Authorization of any kind
    participants_wo_valid= participants_wo_valid.where.not(id: Decidim::Authorization.pluck(:decidim_user_id))

    puts "Participants signed up with email: #{participants_wo_valid.count}"

    case args.action
    when "remove"
      participants_wo_valid.each do |participant|
        print "#{participant.id}? "
        Decidim::Verifications::Conflict.where(current_user_id: participant.id).each do |c|
          print "(conflict #{c.id}: #{c.destroy})"
        end
        Decidim::Verifications::Conflict.where(managed_user_id: participant.id).each do |c|
          print "(conflict #{c.id}: #{c.destroy})"
        end

        puts participant.destroy.to_s
      end
    when "csv"
      puts ""
      participants_wo_valid.each do |participant|
        puts "#{participant.id},\"#{participant.name}\",#{participant.email}"
      end
    end
  end

  desc "Remove orphan Reports, comments or proposals"
  task orphaned_content: :environment do
    puts "#{Decidim::Report.count} reports"
    query= Decidim::Report.joins(:user).where("decidim_users" => { id: nil })
    puts "#{query.count} orphaned reports"
    # query.destroy_all
    puts "#{Decidim::Comments::Comment.count} comments"
    query= Decidim::Comments::Comment.joins("LEFT JOIN decidim_users ON decidim_users.id = decidim_comments_comments.decidim_author_id AND decidim_author_type = 'Decidim::UserBaseEntity'")
                                     .where("decidim_users" => { id: nil })
    puts "#{query.count} orphaned comments"
    # query.destroy_all
    # puts "#{Decidim::Proposals::Proposal.count} proposals"
    # query= Decidim::Proposals::Proposal.joins(:user).where("decidim_users" => { id: nil })
    # puts "#{query.count} orphaned proposals"
    # query.destroy_all
    puts "Done."
  end
end
