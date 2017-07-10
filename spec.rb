require 'rails_helper'

RSpec.describe RubyOptimize, type: :model do
  def ruby_optimize(versions, **params)
    @ruby_optimize = {} if @ruby_optimize.nil?
    scope = params[:scope] || :default
    raise "RubyOptimize - scope already defined: #{scope.inspect}" if @ruby_optimize.has_key?(scope)
    @ruby_optimize[scope] = RubyOptimize.new(versions, scope, request.user_agent, params[:cookie_expiration], params[:version_for_crawler])
  end

  def ruby_optimize_init(scope=:default)
    raise "RubyOptimize - A/B test not initialized" if @ruby_optimize.nil?
    raise "RubyOptimize - scope not found: #{scope.inspect}" if !@ruby_optimize.has_key?(scope)
    @ruby_optimize[scope].init_script
  end

  def ruby_optimize_wrap(*version_and_scope, **params, &block)
    scope = version_and_scope[1] || :default
    raise "RubyOptimize - A/B test not initialized" if @ruby_optimize.nil?
    raise "RubyOptimize - scope not found: #{scope.inspect}" if !@ruby_optimize.has_key?(scope)
    @ruby_optimize[scope].wrap(yield, version_and_scope[0], !!params[:version_for_crawler])
  end

  def fake_wrapped(version, random_div_id, js_object_id)
    "      <div id=\"#{random_div_id}\">\n        hello\n      </div>\n      <script>\n        window['#{js_object_id}'].handle('#{version}', '#{random_div_id}');\n      </script>\n"
  end

  let(:init_script_default) do
     <<-HTML
      <script>
        function xxxxxxxxxxxx(random) {
          var n = 'ruby-optimize-cookie-default=', ca, v = undefined, c;
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
            d.setTime(d.getTime() + (15552000 * 1000));
            document.cookie = 'ruby-optimize-cookie-default=' + v + '; expires=' + d.toGMTString() + '; path=/';
          }

          this.handle = function(version, id) {
            if (version === v) return;
            var el = document.getElementById(id);
            el.parentNode.removeChild(el);
          };
        };

        window['yyyyyyyyyyyy'] = new xxxxxxxxxxxx('zzzzzzzzzzzz');

        window.clearRubyOptimizeCookieDefault = function() {
          document.cookie = 'ruby-optimize-cookie-default=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
        };
      </script>
    HTML
  end

  let(:init_script_test) do
     <<-HTML
      <script>
        function xxxxxxxxxxxx(random) {
          var n = 'ruby-optimize-cookie-test=', ca, v = undefined, c;
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
            d.setTime(d.getTime() + (15552000 * 1000));
            document.cookie = 'ruby-optimize-cookie-test=' + v + '; expires=' + d.toGMTString() + '; path=/';
          }

          this.handle = function(version, id) {
            if (version === v) return;
            var el = document.getElementById(id);
            el.parentNode.removeChild(el);
          };
        };

        window['yyyyyyyyyyyy'] = new xxxxxxxxxxxx('zzzzzzzzzzzz');

        window.clearRubyOptimizeCookieTest = function() {
          document.cookie = 'ruby-optimize-cookie-test=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
        };
      </script>
    HTML
  end

  let(:init_script_test2) do
     <<-HTML
      <script>
        function xxxxxxxxxxxx(random) {
          var n = 'ruby-optimize-cookie-test2=', ca, v = undefined, c;
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
            d.setTime(d.getTime() + (15552000 * 1000));
            document.cookie = 'ruby-optimize-cookie-test2=' + v + '; expires=' + d.toGMTString() + '; path=/';
          }

          this.handle = function(version, id) {
            if (version === v) return;
            var el = document.getElementById(id);
            el.parentNode.removeChild(el);
          };
        };

        window['yyyyyyyyyyyy'] = new xxxxxxxxxxxx('zzzzzzzzzzzz');

        window.clearRubyOptimizeCookieTest2 = function() {
          document.cookie = 'ruby-optimize-cookie-test2=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
        };
      </script>
    HTML
  end

  let(:init_script_test3) do
     <<-HTML
      <script>
        function xxxxxxxxxxxx(random) {
          var n = 'ruby-optimize-cookie-test3=', ca, v = undefined, c;
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
            d.setTime(d.getTime() + (33 * 1000));
            document.cookie = 'ruby-optimize-cookie-test3=' + v + '; expires=' + d.toGMTString() + '; path=/';
          }

          this.handle = function(version, id) {
            if (version === v) return;
            var el = document.getElementById(id);
            el.parentNode.removeChild(el);
          };
        };

        window['yyyyyyyyyyyy'] = new xxxxxxxxxxxx('zzzzzzzzzzzz');

        window.clearRubyOptimizeCookieTest3 = function() {
          document.cookie = 'ruby-optimize-cookie-test3=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
        };
      </script>
    HTML
  end

  let(:init_script_test4) do
     <<-HTML
      <script>
        function xxxxxxxxxxxx(random) {
          var n = 'ruby-optimize-cookie-test4=', ca, v = undefined, c;
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
            d.setTime(d.getTime() + (15552000 * 1000));
            document.cookie = 'ruby-optimize-cookie-test4=' + v + '; expires=' + d.toGMTString() + '; path=/';
          }

          this.handle = function(version, id) {
            if (version === v) return;
            var el = document.getElementById(id);
            el.parentNode.removeChild(el);
          };
        };

        window['yyyyyyyyyyyy'] = new xxxxxxxxxxxx('zzzzzzzzzzzz');

        window.clearRubyOptimizeCookieTest4 = function() {
          document.cookie = 'ruby-optimize-cookie-test4=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
        };
      </script>
    HTML
  end

  describe 'create' do
    context 'not crawler' do
      let(:request) do
        OpenStruct.new(user_agent: 'safari')
      end

      it 'raises an error if "versions" is not an array' do
        expect do
          ruby_optimize 'hello'
        end.to raise_error('RubyOptimize - you need to pass an array of at least two versions: "hello"')
      end

      it 'raises an error if there are less than two versions, 1' do
        expect do
          ruby_optimize [ 'helllo' ]
        end.to raise_error('RubyOptimize - you need to pass an array of at least two versions: ["helllo"]')
      end

      it 'raises an error if there are less than two versions, 2' do
        expect do
          ruby_optimize []
        end.to raise_error('RubyOptimize - you need to pass an array of at least two versions: []')
      end

      it 'raises an error if there versions are not alphanumeric, 1' do
        expect do
          ruby_optimize [ 'v1', :v2 ]
        end.to raise_error('RubyOptimize - versions need to be alphanumeric symbols: ["v1", :v2]')
      end

      it 'raises an error if there versions are not alphanumeric, 2' do
        expect do
          ruby_optimize [ :v1, :v2, 3 ]
        end.to raise_error('RubyOptimize - versions need to be alphanumeric symbols: [:v1, :v2, 3]')
      end

      it 'raises an error if there versions are not alphanumeric, 3' do
        expect do
          ruby_optimize [ :'v-1', :v2, :v3 ]
        end.to raise_error('RubyOptimize - versions need to be alphanumeric symbols: [:"v-1", :v2, :v3]')
      end

      it 'raises an error if there versions are not alphanumeric, 4' do
        expect do
          ruby_optimize [ :'v1-', :v2, :v3 ]
        end.to raise_error('RubyOptimize - versions need to be alphanumeric symbols: [:"v1-", :v2, :v3]')
      end

      it 'raises an error if scope is not alphanumeric, 1' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ], scope: 23
        end.to raise_error('RubyOptimize - scope needs to be an alphanumeric symbol: 23')
      end

      it 'raises an error if scope is not alphanumeric, 2' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ], scope: 'ehi23'
        end.to raise_error('RubyOptimize - scope needs to be an alphanumeric symbol: "ehi23"')
      end

      it 'raises an error if scope is not alphanumeric, 3' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ], scope: :'ehi-'
        end.to raise_error('RubyOptimize - scope needs to be an alphanumeric symbol: :"ehi-"')
      end

      it 'raises an error if cookie_expiration is not a positive integer, 1' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ], cookie_expiration: 'ahi'
        end.to raise_error('RubyOptimize - cookie_expiration needs to be an integer greater than zero: 0')
      end

      it 'raises an error if cookie_expiration is not a positive integer, 2' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ], cookie_expiration: -1
        end.to raise_error('RubyOptimize - cookie_expiration needs to be an integer greater than zero: -1')
      end

      it 'raises an error if version_for_crawler is not one of the whitelisted versions' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ], version_for_crawler: 'ehi'
        end.to raise_error('RubyOptimize - version_for_crawler must be one of the available versions: "ehi"')
      end

      it 'raises an error if version_for_crawler is not one of the whitelisted versions' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ], version_for_crawler: :v4
        end.to raise_error('RubyOptimize - version_for_crawler must be one of the available versions: :v4')
      end

      it 'does not raise any error if cookie_expiration is explicitly nil' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ], cookie_expiration: nil
        end.not_to raise_error
      end

      it 'does not raise any error if version_for_crawler is explicitly nil' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ], version_for_crawler: nil
        end.not_to raise_error
      end

      it 'raises an error if you try to access the same scope twice' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ], scope: :myscope
          ruby_optimize [ :v4, :v5 ], scope: :myscope
        end.to raise_error('RubyOptimize - scope already defined: :myscope')
      end

      it 'raises an error if you try to access the same scope twice (default)' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ]
          ruby_optimize [ :v4, :v5 ]
        end.to raise_error('RubyOptimize - scope already defined: :default')
      end

      it 'raises an error if you try to access the same scope twice (default set explicitly 1)' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ], scope: :default
          ruby_optimize [ :v4, :v5 ]
        end.to raise_error('RubyOptimize - scope already defined: :default')
      end

      it 'raises an error if you try to access the same scope twice (default set explicitly 2)' do
        expect do
          ruby_optimize [ :v1, :v2, :v3 ]
          ruby_optimize [ :v4, :v5 ], scope: :default
        end.to raise_error('RubyOptimize - scope already defined: :default')
      end

      it 'raises an error if you try using the object without having initialized it previously' do
        expect do
          ruby_optimize_init
        end.to raise_error('RubyOptimize - A/B test not initialized')
        expect do
          ruby_optimize_init(:somescope)
        end.to raise_error('RubyOptimize - A/B test not initialized')
        expect do
          ruby_optimize_wrap(:v1) do
            'hello'
          end
        end.to raise_error('RubyOptimize - A/B test not initialized')
        expect do
          ruby_optimize_wrap(:v1, :somescope) do
            'hello'
          end
        end.to raise_error('RubyOptimize - A/B test not initialized')
      end

      it 'correctly sets up the object, init scripts, wrap' do
        ruby_optimize [ :v1, :v2, :v3 ]
        ruby_optimize [ :old, :new ], scope: :test
        ruby_optimize [ :old, :new ], scope: :test2, cookie_expiration: nil, version_for_crawler: nil
        ruby_optimize [ :v4, :v5 ], scope: :test3, cookie_expiration: 33
        ruby_optimize [ :v4, :v5 ], scope: :test4, version_for_crawler: :v5
        expect(@ruby_optimize.class.to_s).to eq('Hash')
        expect(@ruby_optimize.keys.length).to eq(5)
        expect(@ruby_optimize.keys.sort[0]).to eq(:default)
        expect(@ruby_optimize.keys.sort[1]).to eq(:test)
        expect(@ruby_optimize.keys.sort[2]).to eq(:test2)
        expect(@ruby_optimize.keys.sort[3]).to eq(:test3)
        expect(@ruby_optimize.keys.sort[4]).to eq(:test4)
        # INIT SCRIPT GENERIC
        expect do
          ruby_optimize_init(:anotherscope)
        end.to raise_error('RubyOptimize - scope not found: :anotherscope')
        # WRAP GENERIC
        expect do
          ruby_optimize_wrap(:v1, :anotherscope) do
            'hello'
          end
        end.to raise_error('RubyOptimize - scope not found: :anotherscope')
        expect do
          @ruby_optimize[:default].wrap('hello', :v1, 'true') do
            'hello'
          end
        end.to raise_error('RubyOptimize - for_crawler must be a boolean: "true"')
        # DEFAULT SET UP
        def (@ruby_optimize[:default]).get_cookie_expiration
          cookie_expiration
        end
        def (@ruby_optimize[:default]).get_cookie_name
          cookie_name
        end
        def (@ruby_optimize[:default]).get_version_for_crawler
          version_for_crawler
        end
        def (@ruby_optimize[:default]).get_is_crawler
          is_crawler
        end
        def (@ruby_optimize[:default]).get_js_object_id
          js_object_id
        end
        def (@ruby_optimize[:default]).get_versions
          versions
        end
        expect(@ruby_optimize[:default].get_cookie_expiration).to eq(15552000)
        expect(@ruby_optimize[:default].get_cookie_name).to eq('ruby-optimize-cookie-default')
        expect(@ruby_optimize[:default].get_version_for_crawler).to eq(nil)
        expect(@ruby_optimize[:default].get_is_crawler).to eq(false)
        expect(@ruby_optimize[:default].get_versions.sort).to eq([:v1, :v2, :v3])
        # DEFAULT INIT SCRIPT
        js_object_id = @ruby_optimize[:default].get_js_object_id
        js_object_id_for_class_name = "RubyOptimize#{js_object_id.gsub('-', '')}"
        isd = ruby_optimize_init
        expect(isd).to eq(ruby_optimize_init(:default))
        sampled_version = isd.scan(/#{js_object_id_for_class_name}\(\'[a-z0-9]+\'/).first.split("'").last
        processed_init_script_default = init_script_default.gsub('xxxxxxxxxxxx', js_object_id_for_class_name)
        processed_init_script_default.gsub!('yyyyyyyyyyyy', js_object_id)
        processed_init_script_default.gsub!('zzzzzzzzzzzz', sampled_version)
        expect(@ruby_optimize[:default].init_script).to eq(processed_init_script_default)
        # DEFAULT WRAP
        expect do
          ruby_optimize_wrap(:new) do
            'hello'
          end
        end.to raise_error('RubyOptimize - version must be one of the available versions: :new')
        expect(ruby_optimize_wrap do
          'hello'
        end).to eq('')
        wrapped = ruby_optimize_wrap(:v1) do
          'hello'
        end
        random_div_id = wrapped.scan(/div id=\"[a-z0-9\-]+\"/).first.split('"').last
        expect(wrapped).to eq(fake_wrapped('v1', random_div_id, js_object_id))
        wrapped = ruby_optimize_wrap(:v2, :default) do
          'hello'
        end
        random_div_id = wrapped.scan(/div id=\"[a-z0-9\-]+\"/).first.split('"').last
        expect(wrapped).to eq(fake_wrapped('v2', random_div_id, js_object_id))
        wrapped = ruby_optimize_wrap(:v3, :default, version_for_crawler: true) do
          'hello'
        end
        random_div_id = wrapped.scan(/div id=\"[a-z0-9\-]+\"/).first.split('"').last
        expect(wrapped).to eq(fake_wrapped('v3', random_div_id, js_object_id))
        wrapped = ruby_optimize_wrap(:v1, version_for_crawler: true) do
          'hello'
        end
        random_div_id = wrapped.scan(/div id=\"[a-z0-9\-]+\"/).first.split('"').last
        expect(wrapped).to eq(fake_wrapped('v1', random_div_id, js_object_id))
        expect(ruby_optimize_wrap(version_for_crawler: true) do
          'hello'
        end).to eq('')
        # TEST SET UP
        def (@ruby_optimize[:test]).get_cookie_expiration
          cookie_expiration
        end
        def (@ruby_optimize[:test]).get_cookie_name
          cookie_name
        end
        def (@ruby_optimize[:test]).get_version_for_crawler
          version_for_crawler
        end
        def (@ruby_optimize[:test]).get_is_crawler
          is_crawler
        end
        def (@ruby_optimize[:test]).get_js_object_id
          js_object_id
        end
        def (@ruby_optimize[:test]).get_versions
          versions
        end
        expect(@ruby_optimize[:test].get_cookie_expiration).to eq(15552000)
        expect(@ruby_optimize[:test].get_cookie_name).to eq('ruby-optimize-cookie-test')
        expect(@ruby_optimize[:test].get_version_for_crawler).to eq(nil)
        expect(@ruby_optimize[:test].get_is_crawler).to eq(false)
        expect(@ruby_optimize[:test].get_versions.sort).to eq([:new, :old])
        # TEST INIT SCRIPT
        js_object_id = @ruby_optimize[:test].get_js_object_id
        js_object_id_for_class_name = "RubyOptimize#{js_object_id.gsub('-', '')}"
        sampled_version = ruby_optimize_init(:test).scan(/#{js_object_id_for_class_name}\(\'[a-z0-9]+\'/).first.split("'").last
        processed_init_script_test = init_script_test.gsub('xxxxxxxxxxxx', js_object_id_for_class_name)
        processed_init_script_test.gsub!('yyyyyyyyyyyy', js_object_id)
        processed_init_script_test.gsub!('zzzzzzzzzzzz', sampled_version)
        expect(@ruby_optimize[:test].init_script).to eq(processed_init_script_test)
        # TEST WRAP
        expect do
          ruby_optimize_wrap(:v444, :test) do
            'hello'
          end
        end.to raise_error('RubyOptimize - version must be one of the available versions: :v444')
        wrapped = ruby_optimize_wrap(:old, :test) do
          'hello'
        end
        random_div_id = wrapped.scan(/div id=\"[a-z0-9\-]+\"/).first.split('"').last
        expect(wrapped).to eq(fake_wrapped('old', random_div_id, js_object_id))
        wrapped = ruby_optimize_wrap(:new, :test, version_for_crawler: true) do
          'hello'
        end
        random_div_id = wrapped.scan(/div id=\"[a-z0-9\-]+\"/).first.split('"').last
        expect(wrapped).to eq(fake_wrapped('new', random_div_id, js_object_id))
        # TEST2 SET UP
        def (@ruby_optimize[:test2]).get_cookie_expiration
          cookie_expiration
        end
        def (@ruby_optimize[:test2]).get_cookie_name
          cookie_name
        end
        def (@ruby_optimize[:test2]).get_version_for_crawler
          version_for_crawler
        end
        def (@ruby_optimize[:test2]).get_is_crawler
          is_crawler
        end
        def (@ruby_optimize[:test2]).get_js_object_id
          js_object_id
        end
        def (@ruby_optimize[:test2]).get_versions
          versions
        end
        expect(@ruby_optimize[:test2].get_cookie_expiration).to eq(15552000)
        expect(@ruby_optimize[:test2].get_cookie_name).to eq('ruby-optimize-cookie-test2')
        expect(@ruby_optimize[:test2].get_version_for_crawler).to eq(nil)
        expect(@ruby_optimize[:test2].get_is_crawler).to eq(false)
        expect(@ruby_optimize[:test2].get_versions.sort).to eq([:new, :old])
        # TEST2 INIT SCRIPT
        js_object_id = @ruby_optimize[:test2].get_js_object_id
        js_object_id_for_class_name = "RubyOptimize#{js_object_id.gsub('-', '')}"
        sampled_version = ruby_optimize_init(:test2).scan(/#{js_object_id_for_class_name}\(\'[a-z0-9]+\'/).first.split("'").last
        processed_init_script_test2 = init_script_test2.gsub('xxxxxxxxxxxx', js_object_id_for_class_name)
        processed_init_script_test2.gsub!('yyyyyyyyyyyy', js_object_id)
        processed_init_script_test2.gsub!('zzzzzzzzzzzz', sampled_version)
        expect(@ruby_optimize[:test2].init_script).to eq(processed_init_script_test2)
        # TEST2 WRAP
        expect do
          ruby_optimize_wrap(:v444, :test2) do
            'hello'
          end
        end.to raise_error('RubyOptimize - version must be one of the available versions: :v444')
        wrapped = ruby_optimize_wrap(:old, :test2) do
          'hello'
        end
        random_div_id = wrapped.scan(/div id=\"[a-z0-9\-]+\"/).first.split('"').last
        expect(wrapped).to eq(fake_wrapped('old', random_div_id, js_object_id))
        wrapped = ruby_optimize_wrap(:new, :test2, version_for_crawler: true) do
          'hello'
        end
        random_div_id = wrapped.scan(/div id=\"[a-z0-9\-]+\"/).first.split('"').last
        expect(wrapped).to eq(fake_wrapped('new', random_div_id, js_object_id))
        # TEST3 SET UP
        def (@ruby_optimize[:test3]).get_cookie_expiration
          cookie_expiration
        end
        def (@ruby_optimize[:test3]).get_cookie_name
          cookie_name
        end
        def (@ruby_optimize[:test3]).get_version_for_crawler
          version_for_crawler
        end
        def (@ruby_optimize[:test3]).get_is_crawler
          is_crawler
        end
        def (@ruby_optimize[:test3]).get_js_object_id
          js_object_id
        end
        def (@ruby_optimize[:test3]).get_versions
          versions
        end
        expect(@ruby_optimize[:test3].get_cookie_expiration).to eq(33)
        expect(@ruby_optimize[:test3].get_cookie_name).to eq('ruby-optimize-cookie-test3')
        expect(@ruby_optimize[:test3].get_version_for_crawler).to eq(nil)
        expect(@ruby_optimize[:test3].get_is_crawler).to eq(false)
        expect(@ruby_optimize[:test3].get_versions.sort).to eq([:v4, :v5])
        # TEST3 INIT SCRIPT
        js_object_id = @ruby_optimize[:test3].get_js_object_id
        js_object_id_for_class_name = "RubyOptimize#{js_object_id.gsub('-', '')}"
        sampled_version = ruby_optimize_init(:test3).scan(/#{js_object_id_for_class_name}\(\'[a-z0-9]+\'/).first.split("'").last
        processed_init_script_test3 = init_script_test3.gsub('xxxxxxxxxxxx', js_object_id_for_class_name)
        processed_init_script_test3.gsub!('yyyyyyyyyyyy', js_object_id)
        processed_init_script_test3.gsub!('zzzzzzzzzzzz', sampled_version)
        expect(@ruby_optimize[:test3].init_script).to eq(processed_init_script_test3)
        # TEST3 WRAP
        expect do
          ruby_optimize_wrap(:v444, :test3) do
            'hello'
          end
        end.to raise_error('RubyOptimize - version must be one of the available versions: :v444')
        wrapped = ruby_optimize_wrap(:v4, :test3) do
          'hello'
        end
        random_div_id = wrapped.scan(/div id=\"[a-z0-9\-]+\"/).first.split('"').last
        expect(wrapped).to eq(fake_wrapped('v4', random_div_id, js_object_id))
        wrapped = ruby_optimize_wrap(:v5, :test3, version_for_crawler: true) do
          'hello'
        end
        random_div_id = wrapped.scan(/div id=\"[a-z0-9\-]+\"/).first.split('"').last
        expect(wrapped).to eq(fake_wrapped('v5', random_div_id, js_object_id))
        # TEST4 SET UP
        def (@ruby_optimize[:test4]).get_cookie_expiration
          cookie_expiration
        end
        def (@ruby_optimize[:test4]).get_cookie_name
          cookie_name
        end
        def (@ruby_optimize[:test4]).get_version_for_crawler
          version_for_crawler
        end
        def (@ruby_optimize[:test4]).get_is_crawler
          is_crawler
        end
        def (@ruby_optimize[:test4]).get_js_object_id
          js_object_id
        end
        def (@ruby_optimize[:test4]).get_versions
          versions
        end
        expect(@ruby_optimize[:test4].get_cookie_expiration).to eq(15552000)
        expect(@ruby_optimize[:test4].get_cookie_name).to eq('ruby-optimize-cookie-test4')
        expect(@ruby_optimize[:test4].get_version_for_crawler).to eq(:v5)
        expect(@ruby_optimize[:test4].get_is_crawler).to eq(false)
        expect(@ruby_optimize[:test4].get_versions.sort).to eq([:v4, :v5])
        # TEST4 INIT SCRIPT
        js_object_id = @ruby_optimize[:test4].get_js_object_id
        js_object_id_for_class_name = "RubyOptimize#{js_object_id.gsub('-', '')}"
        sampled_version = ruby_optimize_init(:test4).scan(/#{js_object_id_for_class_name}\(\'[a-z0-9]+\'/).first.split("'").last
        processed_init_script_test4 = init_script_test4.gsub('xxxxxxxxxxxx', js_object_id_for_class_name)
        processed_init_script_test4.gsub!('yyyyyyyyyyyy', js_object_id)
        processed_init_script_test4.gsub!('zzzzzzzzzzzz', sampled_version)
        expect(@ruby_optimize[:test4].init_script).to eq(processed_init_script_test4)
        # TEST4 WRAP
        expect do
          ruby_optimize_wrap(:v444, :test4) do
            'hello'
          end
        end.to raise_error('RubyOptimize - version must be one of the available versions: :v444')
        wrapped = ruby_optimize_wrap(:v5, :test4) do
          'hello'
        end
        random_div_id = wrapped.scan(/div id=\"[a-z0-9\-]+\"/).first.split('"').last
        expect(wrapped).to eq(fake_wrapped('v5', random_div_id, js_object_id))
        wrapped = ruby_optimize_wrap(:v4, :test4, version_for_crawler: true) do
          'hello'
        end
        random_div_id = wrapped.scan(/div id=\"[a-z0-9\-]+\"/).first.split('"').last
        expect(wrapped).to eq(fake_wrapped('v4', random_div_id, js_object_id))
      end
    end

    context 'crawler' do
      let(:request) do
        OpenStruct.new(user_agent: 'summify')
      end

      it 'correctly sets up the object, empty init scripts, empty wrap' do
        ruby_optimize [ :v1, :v2, :v3 ]
        ruby_optimize [ :old, :new ], scope: :test, version_for_crawler: :old
        # INIT SCRIPT GENERIC
        expect do
          ruby_optimize_init(:anotherscope)
        end.to raise_error('RubyOptimize - scope not found: :anotherscope')
        # WRAP GENERIC
        expect do
          ruby_optimize_wrap(:v1, :anotherscope) do
            'hello'
          end
        end.to raise_error('RubyOptimize - scope not found: :anotherscope')
        expect do
          @ruby_optimize[:default].wrap('hello', :v1, 'true') do
            'hello'
          end
        end.to raise_error('RubyOptimize - for_crawler must be a boolean: "true"')
        # DEFAULT SET UP
        def (@ruby_optimize[:default]).get_cookie_expiration
          cookie_expiration
        end
        def (@ruby_optimize[:default]).get_cookie_name
          cookie_name
        end
        def (@ruby_optimize[:default]).get_version_for_crawler
          version_for_crawler
        end
        def (@ruby_optimize[:default]).get_is_crawler
          is_crawler
        end
        def (@ruby_optimize[:default]).get_js_object_id
          js_object_id
        end
        def (@ruby_optimize[:default]).get_versions
          versions
        end
        expect(@ruby_optimize[:default].get_cookie_expiration).to eq(15552000)
        expect(@ruby_optimize[:default].get_cookie_name).to eq('ruby-optimize-cookie-default')
        expect(@ruby_optimize[:default].get_version_for_crawler).to eq(nil)
        expect(@ruby_optimize[:default].get_is_crawler).to eq(true)
        expect(@ruby_optimize[:default].get_versions.sort).to eq([:v1, :v2, :v3])
        # DEFAULT INIT SCRIPT
        expect(ruby_optimize_init(:default)).to eq('')
        expect(ruby_optimize_init).to eq('')
        # DEFAULT WRAP
        expect(ruby_optimize_wrap(:xxx) do
          'hello'
        end).to eq('')
        expect(ruby_optimize_wrap do
          'hello'
        end).to eq('')
        expect(ruby_optimize_wrap(:v1) do
          'hello'
        end).to eq('')
        expect(ruby_optimize_wrap(:v2, :default) do
          'hello'
        end).to eq('')
        expect(ruby_optimize_wrap(:v3, :default, version_for_crawler: true) do
          'hello'
        end).to eq('hello')
        expect(ruby_optimize_wrap(:v1, version_for_crawler: true) do
          'hello'
        end).to eq('hello')
        expect(ruby_optimize_wrap(version_for_crawler: true) do
          'hello'
        end).to eq('hello')
        # TEST SET UP
        def (@ruby_optimize[:test]).get_cookie_expiration
          cookie_expiration
        end
        def (@ruby_optimize[:test]).get_cookie_name
          cookie_name
        end
        def (@ruby_optimize[:test]).get_version_for_crawler
          version_for_crawler
        end
        def (@ruby_optimize[:test]).get_is_crawler
          is_crawler
        end
        def (@ruby_optimize[:test]).get_js_object_id
          js_object_id
        end
        def (@ruby_optimize[:test]).get_versions
          versions
        end
        expect(@ruby_optimize[:test].get_cookie_expiration).to eq(15552000)
        expect(@ruby_optimize[:test].get_cookie_name).to eq('ruby-optimize-cookie-test')
        expect(@ruby_optimize[:test].get_version_for_crawler).to eq(:old)
        expect(@ruby_optimize[:test].get_is_crawler).to eq(true)
        expect(@ruby_optimize[:test].get_versions.sort).to eq([:new, :old])
        # TEST INIT SCRIPT
        expect(ruby_optimize_init(:test)).to eq('')
        expect(ruby_optimize_init).to eq('')
        # TEST WRAP
        expect(ruby_optimize_wrap(:xxx, :test) do
          'hello'
        end).to eq('')
        expect(ruby_optimize_wrap(:old, :test) do
          'hello'
        end).to eq('hello')
        expect(ruby_optimize_wrap(:new, :test) do
          'hello'
        end).to eq('')
        expect(ruby_optimize_wrap(:old, :test, version_for_crawler: true) do
          'hello'
        end).to eq('hello')
        expect(ruby_optimize_wrap(:new, :test, version_for_crawler: true) do
          'hello'
        end).to eq('hello')
      end
    end
  end
end
