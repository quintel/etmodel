# frozen_string_literal: true

require 'rails_helper'

describe ScenarioHelper do
  describe '.formatted_scenario_description' do
    let(:formatted) { helper.formatted_scenario_description(text).strip }
    let(:nokogiri) { Nokogiri::HTML(formatted) }

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

    context 'with a relative link' do
      let(:text) { '[Relative](/example)' }

      it 'keeps the link intact' do
        expect(formatted).to eq('<p><a href="/example">Relative</a></p>')
      end
    end

    context 'with an external link' do
      let(:text) { '[Absolute](http://example/org)' }

      it 'replaces the link with the text' do
        expect(formatted).to eq('<p>Absolute</p>')
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
end
