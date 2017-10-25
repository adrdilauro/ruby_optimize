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

    attr_reader :init_script

    def initialize(some_versions, scope, agent, a_cookie_expiration=nil, a_version_for_crawler=nil)
      @versions = some_versions
      validate_versions
      validate_scope(scope)
      @cookie_name = "ruby-optimize-cookie-#{scope}"
      @is_crawler = !CRAWLER.match(agent).nil?
      @cookie_expiration = (a_cookie_expiration || 180.days).to_i
      validate_cookie_expiration
      @version_for_crawler = a_version_for_crawler
      validate_version_for_crawler
      @js_object_id = SecureRandom.uuid
      setup_init_script
    end

    def wrap(html, version, for_crawler)
      raise "RubyOptimize - for_crawler must be a boolean: #{for_crawler.inspect}" if for_crawler != !!for_crawler
      if is_crawler
        return html.html_safe if for_crawler
        return html.html_safe if !version_for_crawler.nil? && version == version_for_crawler
        return ''
      end
      raise "RubyOptimize - version must be one of the available versions: #{version.inspect}" if !version.nil? && !versions.include?(version)
      return '' if !version.present?
      id = SecureRandom.uuid
      wrapped = <<-HTML
        <div id="#{id}" style="display:none">
          #{html}
        </div>
        <script>
          window['#{js_object_id}'].handle('#{version}', '#{id}');
        </script>
      HTML
      wrapped.html_safe
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

    def setup_init_script
      if is_crawler
        @init_script = ''
        return
      end
      js_object_id_for_class_name = "RubyOptimize#{js_object_id.gsub('-', '')}"
      @init_script = <<-HTML
        <script>
          function #{js_object_id_for_class_name}(random) {
            var n = '#{cookie_name}=', ca, v = undefined, c;
            ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
              c = ca[i];
              while (c.charAt(0) === ' ') {
                c = c.substring(1, c.length);
              }
              if (c.indexOf(n) === 0) {
                v = c.substring(n.length, c.length);
              }
            }
            if (v === undefined) {
              v = random;
              var d = new Date();
              d.setTime(d.getTime() + (#{cookie_expiration} * 1000));
              document.cookie = '#{cookie_name}=' + v + '; expires=' + d.toGMTString() + '; path=/';
            }

            this.handle = function(version, id) {
              var el = document.getElementById(id);
              if (version === v) {
                el.style.removeProperty('display');
                return;
              }
              el.parentNode.removeChild(el);
            };
          };

          window['#{js_object_id}'] = new #{js_object_id_for_class_name}('#{versions.sample}');

          window.clearRubyOptimizeCookie#{cookie_name.split("-").last.camelcase} = function() {
            document.cookie = '#{cookie_name}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
          };
        </script>
      HTML
      @init_script = init_script.html_safe
    end

    attr_reader :cookie_expiration, :cookie_name, :version_for_crawler, :is_crawler, :js_object_id, :versions
  end
end
