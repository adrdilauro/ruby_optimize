module RubyOptimize
  class AbTestHandler
    ALPHANUMERIC_STRING = /\A[a-zA-Z0-9]+\z/
    CRAWLER = /#{[
      'bot', 'crawl', 'slurp', 'spider', 'Google favicon', 'Mediapartners-Google', 'java', 'wget', 'curl', 'Commons-HttpClient',
      'Python-urllib', 'libwww', 'httpunit', 'nutch', 'biglotron', 'teoma', 'convera', 'gigablast', 'ia_archiver', 'webmon',
      'httrack', 'grub.org', 'netresearchserver', 'speedy', 'fluffy', 'bibnum.bnf', 'findlink', 'panscient', 'IOI', 'ips-agent',
      'yanga', 'Voyager', 'CyberPatrol', 'postrank', 'page2rss', 'linkdex', 'ezooms', 'heritrix', 'findthatfile', 'europarchive.org',
      'Aboundex', 'summify', 'ec2linkfinder', 'facebookexternalhit', 'yeti', 'RetrevoPageAnalyzer', 'sogou', 'wotbox', 'ichiro',
      'drupact', 'coccoc', 'integromedb', 'siteexplorer.info', 'proximic', 'changedetection', 'WeSEE:SearchLipperhey SEO Service',
      'CC Metadata Scaper', 'g00g1e.net', 'binlar', 'A6-Indexer', 'ADmantX', 'MegaIndex', 'ltx71', 'BUbiNG', 'Qwantify', 'lipperhey',
      'y!j-asr', 'AddThis'
    ].join('|')}/i

    def initialize(cookies, some_versions, scope, agent, domain=nil, a_cookie_expiration=nil, a_version_for_crawler=nil, use_session_cookies=false, custom_weights={})
      @versions = some_versions
      validate_versions
      validate_scope(scope)
      @cookie_name = "ruby-optimize-cookie-#{scope}"
      @is_crawler = !CRAWLER.match(agent).nil?
      @cookie_expiration = (a_cookie_expiration || 180.days).to_i
      validate_cookie_expiration
      @version_for_crawler = a_version_for_crawler
      validate_version_for_crawler
      return if is_crawler
      if cookies.has_key?(cookie_name)
        @version = cookies[cookie_name].to_sym
      else
        @version = extract_random_version(custom_weights)
        cookie_hash = {
          value: version,
          domain: domain || :all,
        }
        cookie_hash[:expires] = cookie_expiration.from_now if !use_session_cookies
        cookies[cookie_name] = cookie_hash
      end
    end

    def show?(a_version, for_crawler)
      raise "RubyOptimize - for_crawler must be a boolean: #{for_crawler.inspect}" if for_crawler != !!for_crawler
      return for_crawler || (!version_for_crawler.nil? && a_version == version_for_crawler) if is_crawler
      raise "RubyOptimize - version must be one of the available versions: #{a_version.inspect}" if !versions.include?(a_version)
      a_version == version
    end

    private

    def validate_versions
      raise "RubyOptimize - you need to pass an array of at least two versions: #{versions.inspect}" if !versions.is_a?(Array) || versions.length < 2
      raise "RubyOptimize - versions need to be alphanumeric symbols: #{versions.inspect}" if versions.any? do |version|
        !version.is_a?(Symbol) || ALPHANUMERIC_STRING.match(version.to_s).nil?
      end
    end

    def validate_scope(scope)
      raise "RubyOptimize - scope needs to be an alphanumeric symbol: #{scope.inspect}" if !scope.is_a?(Symbol) || ALPHANUMERIC_STRING.match(scope.to_s).nil?
    end

    def validate_cookie_expiration
      raise "RubyOptimize - cookie_expiration needs to be an integer greater than zero: #{cookie_expiration.inspect}" if cookie_expiration <= 0
    end

    def validate_version_for_crawler
      raise "RubyOptimize - version_for_crawler must be one of the available versions: #{version_for_crawler.inspect}" if !version_for_crawler.nil? && !versions.include?(version_for_crawler)
    end

    def validate_weight_against_versions(weight_version)
      raise "RubyOptimize - weight associated to a non declared version: #{weight_version.inspect}" if !versions.include?(weight_version)
    end

    def validate_total_declared_weight(total_weight)
      raise "RubyOptimize - sum of declared weights is greater than 100: #{total_weight.inspect}" if total_weight >= 100
    end

    def extract_random_version(weights)
      processed_weights = []
      total_weight = 0
      temp_versions = versions.clone
      index = 0
      weights.each do |key, value|
        validate_weight_against_versions(key)
        temp_versions.delete(key)
        total_weight += value.to_f.round(2)
        processed_weights << [ total_weight, key ]
      end
      validate_total_declared_weight(total_weight)
      remaining_weight = ((100 - total_weight).to_f / temp_versions.length).round(2)
      temp_versions.each do |a_version|
        total_weight += remaining_weight
        processed_weights << [ total_weight, a_version ]
      end
      processed_weights[processed_weights.length - 1] = [ 100, processed_weights[processed_weights.length - 1][1] ]
      extracted_number = rand() * 100
      processed_weights.each do |weight_and_version|
        return weight_and_version[1] if extracted_number <= weight_and_version[0]
      end
    end

    attr_reader :cookie_expiration, :cookie_name, :version_for_crawler, :is_crawler, :version, :versions
  end
end
