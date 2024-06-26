require "google/cloud/storage"
require "active_support/core_ext/object/to_query"

class ActiveStorage::Service::GCSService < ActiveStorage::Service
  attr_reader :client, :bucket

  def upload(key, io, checksum: nil)
    instrument :upload, key, checksum: checksum do
      begin
        bucket.create_file(io, key, md5: checksum)
      rescue Google::Cloud::InvalidArgumentError
        raise ActiveStorage::IntegrityError
      end
    end
  end

  # FIXME: Add streaming when given a block
  def download(key)
    instrument :download, key do
      io = file_for(key).download
      io.rewind
      io.read
    end
  end

  def delete(key)
    instrument :delete, key do
      file_for(key)&.delete
    end
  end

  def exist?(key)
    instrument :exist, key do |payload|
      payload[:exist] = file_for(key).present?
    end
  end

  def url(key, expires_in:, disposition:, filename:)
    instrument :url, key do |payload|
      query = { "response-content-disposition" => "#{disposition}; filename=\"#{filename}\"" }
      payload[:url] = file_for(key).signed_url(expires: expires_in, query: query)
    end
  end

  private
    def file_for(key)
      bucket.file(key)
    end
end
