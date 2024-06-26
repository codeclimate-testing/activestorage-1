require "active_storage/blob"
require "active_storage/attachment"

require "action_dispatch/http/upload"
require "active_support/core_ext/module/delegation"

require "global_id/locator"

class ActiveStorage::Attached
  attr_reader :name, :record

  def initialize(name, record)
    @name, @record = name, record
  end

  private
    def create_blob_from(attachable)
      case attachable
      when ActiveStorage::Blob
        attachable
      when Hash
        ActiveStorage::Blob.create_after_upload!(attachable)
      when String
        GlobalID::Locator.locate_signed(attachable)
      else
        nil
      end
    end
end

require "active_storage/attached/one"
require "active_storage/attached/many"
require "active_storage/attached/macros"
