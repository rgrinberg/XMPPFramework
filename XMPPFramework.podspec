#
# Be sure to run `pod spec lint MGDablooms.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "XMPPFramework"
  s.version      = "0.0.1"
  s.summary      = "A short description of MGDablooms."
  # s.description  = <<-DESC
  #                   An optional longer description of MGDablooms
  #
  #                   * Markdown format.
  #                   * Don't worry about the indent, we strip it!
  #                  DESC
  s.homepage     = "http://EXAMPLE/MGDablooms"
  # s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"

  # Specify the license type. CocoaPods detects automatically the license file if it is named
  # 'LICENCE*.*' or 'LICENSE*.*', however if the name is different, specify it.
  s.license      = 'Private'
  # s.license      = { :type => 'MIT (example)', :file => 'FILE_LICENSE' }

  # Specify the authors of the library, with email addresses. You can often find
  # the email addresses of the authors by using the SCM log. E.g. $ git log
  #
  s.author       = { "Bradford Toney" => "bradford.toney@gmail.com" }
  # s.authors      = { "Bradford Toney" => "bradford.toney@gmail.com", "other author" => "and email address" }
  #
  # If absolutely no email addresses are available, then you can use this form instead.
  #

  # Specify the location from where the source should be retrieved.
  #
  s.source       = { :git => "git@github.com:Medigram/XMPPFramework.git"}


  s.description = 'XMPPFramework provides a core implementation of RFC-3920 (the xmpp standard), along with
                  the tools needed to read & write XML. It comes with multiple popular extensions (XEP\'s),
                  all built atop a modular architecture, allowing you to plug-in any code needed for the job.
                  Additionally the framework is massively parallel and thread-safe. Structured using GCD,
                  this framework performs well regardless of whether it\'s being run on an old iPhone, or
                  on a 12-core Mac Pro. (And it won\'t block the main thread... at all).'
  s.requires_arc = true

  s.subspec 'Core' do |core|
    core.source_files = FileList['Core/**/*.{h,m}','Vendor/libidn/*.h'].exclude('**/XMPPFramework.h')
    core.resource = "Vendor/libidn/libidn.a"
    core.libraries = 'xml2','resolv','idn'
    core.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2 $(SDKROOT)/usr/include/libresolv',
                      'LIBRARY_SEARCH_PATHS' => '$(PODS_ROOT)/XMPPFramework/Vendor/libidn'}
    
    core.dependency 'XMPPFramework/Authentication'
    core.dependency 'XMPPFramework/Categories'
    core.dependency 'XMPPFramework/Utilities'
    core.ios.dependency 'XMPPFramework/KissXML'
    core.dependency 'CocoaLumberjack','~>1.6'
    core.dependency 'CocoaAsyncSocket','~>0.0.1'
  end

  s.subspec 'Extensions' do |extensions|
    extensions.dependency 'XMPPFramework/Core'
    extensions.source_files = FileList['Extensions/**/*.{h,m}'].exclude('Extensions/**/XMPPRoster.m', 'Extensions/**/XMPPMessageArchiving.m', 'Extensions/**/XMPPJabberRPCModule.m')
  end

  s.subspec 'Authentication' do |authentication|
   authentication.source_files =  'Authentication/**/*.{h,m}'
   authentication.dependency 'XMPPFramework/Core'
  end

  s.subspec 'Categories' do |categories|
   categories.source_files =  'Categories/**/*.{h,m}'
   categories.dependency 'XMPPFramework/Core'
  end

  s.subspec 'Utilities' do |utilities|
   utilities.source_files =  'Utilities/**/*.{h,m}'
   utilities.dependency 'XMPPFramework/Core'
  end
  
  s.subspec 'KissXML' do |kissxml|
   kissxml.source_files = 'Vendor/KissXML/**/*.{h,m}'
   kissxml.dependency 'XMPPFramework/Core'
  end

  s.subspec 'BandwidthMonitor' do |bwm|
    bwm.source_files = 'Extensions/BandwidthMonitor'
    bwm.dependency 'XMPPFramework/Core'
  end

  s.subspec 'CoreDataStorage' do |cds|
    cds.source_files = 'Extensions/CoreDataStorage/**/*.{h,m}'
    cds.framework  = 'CoreData'
    cds.dependency 'XMPPFramework/Core'
  end

  s.subspec 'ProcessOne' do |po|
    po.source_files = 'Extensions/ProcessOne/**/*.{h,m}'
    po.dependency 'XMPPFramework/Core'
  end

  s.subspec 'Reconnect' do |rc|
    rc.source_files = 'Extensions/Reconnect/**/*.{h,m}'
    rc.framework = 'SystemConfiguration'
    rc.dependency 'XMPPFramework/Core'
  end
end
