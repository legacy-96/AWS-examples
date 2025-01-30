require 'aws-sdk-s3'  # AWS SDK for S3 operations
require 'pry'         # Debugging tool
require 'securerandom' # For generating unique file content

# Retrieve the S3 bucket name from environment variables
bucket_name = ENV['BUCKET_NAME']
region = 'ca-central-1'
# Initialize an AWS S3 client
client = Aws::S3::Client.new(region: region)

# Create a new S3 bucket with the specified name
resp = client.create_bucket({
    bucket: bucket_name,
    create_bucket_configuration: {
        location_constraint: region # Ensure 'region' is defined elsewhere in your script
    }
})


# Generate a random number of files (between 1 and 6) to be uploaded to S3
number_of_files = 1 + rand(6)
puts "Number of files: #{number_of_files}"

# Loop to create and upload files to S3
number_of_files.times.each do |i|
    puts "Creating file index: #{i}"
    
    filename = "file_#{i}.txt"
    output_path = "/tmp/#{filename}"

    # Create a local file with a random UUID as content
    File.open(output_path, "w") do |f|
        f.write SecureRandom.uuid
    end

    # Upload the file to the specified S3 bucket
    File.open(output_path, 'rb') do |file|
        client.put_object(
            bucket: bucket_name, 
            key: filename, 
            body: file
        )
    end
end
