# frozen_string_literal: true

namespace :spid do
  task :certificate do
    Rake::Task["environment"].invoke if defined?(Rails)

    if File.exist?(Spid.configuration.certificate_path) &&
       File.exist?(Spid.configuration.private_key_path)
      puts "A certificate and a private key already exists!"
      exit
    end

    private_key = OpenSSL::PKey::RSA.new(4096)
    public_key = private_key.public_key

    subject = {}

    print "Insert the certificate Country (default IT): "
    subject[:C] = $stdin.gets.chomp
    subject[:C] = "IT" if subject[:C] == ""

    print "Insert the Organization name: "
    subject[:O] = $stdin.gets.chomp

    print "Insert the Organization Unit name: "
    subject[:OU] = $stdin.gets.chomp

    print "Insert the Common Name: "
    subject[:CN] = $stdin.gets.chomp

    print "Insert the Domain Component: "
    subject[:DC] = $stdin.gets.chomp

    print "Insert the State or Province name: "
    subject[:ST] = $stdin.gets.chomp

    subject = subject.map do |key, value|
      "/#{key}=#{value}" if !value.nil? && value != ""
    end.join

    certificate = OpenSSL::X509::Certificate.new
    name = OpenSSL::X509::Name.parse(subject)
    certificate.issuer = certificate.subject = name
    certificate.not_before = Time.now
    certificate.not_after = Time.now + (30 * 365 * 24 * 60 * 60)
    certificate.public_key = public_key
    certificate.serial = 0x0
    certificate.version = 2

    certificate.sign private_key, OpenSSL::Digest::SHA512.new

    File.open(Spid.configuration.certificate_path, "w") do |f|
      f.write certificate.to_pem
    end

    File.open(Spid.configuration.private_key_path, "w") do |f|
      f.write private_key.to_pem
    end
  end
end
