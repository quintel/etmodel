# frozen_string_literal: true

require 'rails_helper'

shared_examples 'a scenario description with links' do
  context 'with a relative link' do
    let(:text) { '[Relative](/example)' }

    it 'keeps the link intact' do
      expect(formatted).to eq('<p><a href="/example">Relative</a></p>')
    end
  end

  context 'with a relative link and trailing whitespace' do
    let(:text) { '<a href="/hi ">Hello</a>' }

    it 'keeps the link intact' do
      expect(formatted).to eq('<p><a href="/hi%20">Hello</a></p>')
    end
  end

  context 'with an absolute link to the same host' do
    let(:text) { '[Ok](http://test.host/hi)' }

    it 'keeps the link intact' do
      expect(formatted).to eq('<p><a href="http://test.host/hi">Ok</a></p>')
    end
  end

  context 'with an absolute link to a subdomain of the same domain' do
    let(:text) { '[Ok](http://another.test.host/hi)' }

    it 'keeps the link intact' do
      expect(formatted).to eq(
        '<p><a href="http://another.test.host/hi">Ok</a></p>'
      )
    end
  end

  context 'with an invalid link' do
    let(:text) { '<a href="::no">Hello</a>' }

    it 'replaces the link with the text' do
      expect(formatted).to eq('<p>Hello</p>')
    end
  end
end

describe ScenarioHelper do
  describe '.formatted_scenario_description' do
    let(:formatted) do
      helper.formatted_scenario_description(text, allow_external_links: allow_external).strip
    end

    let(:nokogiri) { Nokogiri::HTML(formatted) }
    let(:allow_external) { false }

    context 'with a locale div' do
      around do |example|
        prev_locale = I18n.locale
        I18n.locale = :nl

        example.run

        I18n.locale = prev_locale
      end

      let(:text) do
        <<~HTML
          <div class="en">Hello! [Link](/link)</div>
          <div class="nl">Hallo! [Link](/link)</div>
        HTML
      end

      it 'extracts the locale text' do
        # Markdown adds the paragraph.
        expect(formatted).to eq('<p>Hallo! <a href="/link">Link</a></p>')
      end
    end

    context 'with two paragraphs' do
      let(:text) { "Paragraph one\n\nParagraph two" }

      it 'formats text as HTML using Markdown' do
        expect(nokogiri.css('p').count).not_to be_zero
      end
    end

    context 'when external links are disallowed' do
      include_examples 'a scenario description with links'

      describe 'when the text contains an external link' do
        let(:text) { '[Absolute](http://example.org)' }

        it 'replaces the link with the text' do
          expect(formatted).to eq('<p>Absolute</p>')
        end
      end

      describe 'when the text contains a mailto link' do
        let(:text) { '[MailTo](mailto:me@example.org)' }

        it 'replaces the link with the text' do
          expect(formatted).to eq('<p>MailTo</p>')
        end
      end
    end

    describe 'when external links are allowed' do
      let(:allow_external) { true }

      include_examples 'a scenario description with links'

      describe 'when the text contains an external link' do
        let(:text) { '[Absolute](http://example.org)' }

        it 'keeps the link, adding a rel attribute' do
          expect(formatted).to eq(
            '<p><a href="http://example.org" rel="noopener nofollow">Absolute</a></p>'
          )
        end
      end

      describe 'when the text contains a mailto link' do
        let(:text) { '[MailTo](mailto:me@example.org)' }

        it 'replaces the link with the text' do
          expect(formatted).to eq('<p>MailTo</p>')
        end
      end
    end

    context 'with a markdown image' do
      let(:text) { 'Hello ![Alt](/img.png)' }

      it 'does not process the image' do
        expect(formatted).to eq('<p>Hello ![Alt](/img.png)</p>')
      end
    end

    context 'with an HTML image' do
      let(:text) { 'Hello <img src="/img.png" />' }

      it 'HTML escapes the image' do
        expect(formatted).to eq(
          "<p>Hello &lt;img src=\u201C/img.png\u201D /&gt;</p>"
        )
      end
    end

    context 'with a frame' do
      let(:text) { '<p><frame src="/hi"/ ></p>' }

      it 'strips the frame' do
        expect(formatted).to eq('<p></p>')
      end
    end

    context 'with a script' do
      let(:text) { '<p><script src="/hi"></script></p>' }

      it 'strips the script' do
        expect(formatted).to eq('<p></p>')
      end
    end

    context 'with malformed elements' do
      let(:text) { '</em>' }

      it 'strips the invalid content' do
        expect(formatted).to eq('<p></p>')
      end
    end
  end

  describe '.strip_external_links' do
    it 'keeps /example' do
      expect(
        helper.strip_external_links('<a href="/example">Hi</a>')
      ).to eq('<a href="/example">Hi</a>')
    end

    it 'keeps //example' do
      expect(
        helper.strip_external_links('<a href="//example">Hi</a>')
      ).to eq('<a href="//example">Hi</a>')
    end

    it 'replaces http://example' do
      expect(
        helper.strip_external_links('<a href="http://example">Hi</a>')
      ).to eq('Hi')
    end

    it 'replaces http://example.org' do
      expect(
        helper.strip_external_links('<a href="http://example.org">Hi</a>')
      ).to eq('Hi')
    end

    it 'replaces https://example.org' do
      expect(
        helper.strip_external_links('<a href="https://example.org">Hi</a>')
      ).to eq('Hi')
    end

    it 'replaces http:///example' do
      expect(
        helper.strip_external_links('<a href="http:///example">Hi</a>')
      ).to eq('Hi')
    end

    it 'replaces ftp://example' do
      expect(
        helper.strip_external_links('<a href="ftp://example">Hi</a>')
      ).to eq('Hi')
    end

    it 'replaces http://localhost' do
      expect(
        helper.strip_external_links('<a href="http://localhost">Hi</a>')
      ).to eq('Hi')
    end

    it 'replaces http://127.0.0.1' do
      expect(
        helper.strip_external_links('<a href="http://127.0.0.1">Hi</a>')
      ).to eq('Hi')
    end

    # it 'replaces <frame src="/no" />' do
    #   expect(
    #     helper.strip_html_links('<frame src="/no" />')
    #   ).to eq('')
    # end

    # it 'replaces <script src="/no" />' do
    #   expect(
    #     helper.strip_html_links('<script src="/no" />')
    #   ).to eq('')
    # end
  end

  describe '.format_subscripts' do
    context 'with "My CO2 scenario"' do
      it 'returns "My CO<sub>2</sub> scenario' do
        expect(helper.format_subscripts('My CO2 scenario')).to eq('My CO<sub>2</sub> scenario')
      end
    end

    context 'with "My CO2A scenario"' do
      it 'returns "My CO2A scenario' do
        expect(helper.format_subscripts('My CO2A scenario')).to eq('My CO2A scenario')
      end
    end

    context 'with "My CO2-sturing scenario"' do
      it 'returns "My CO<sub>2</sub>-sturing scenario' do
        expect(helper.format_subscripts('My CO2-sturing scenario'))
          .to eq('My CO<sub>2</sub>-sturing scenario')
      end
    end

    context 'with "My <strong>scenario</strong>' do
      it 'returns "My &lt;strong&gt;scenario&lt;/strong&gt;' do
        expect(helper.format_subscripts('My <strong>scenario</strong>'))
          .to eq('My &lt;strong&gt;scenario&lt;/strong&gt;')
      end
    end

    context 'with nil' do
      it 'returns nil' do
        expect(helper.format_subscripts(nil)).to be_nil
      end
    end
  end
end
