/* globals _ $ Backbone I18n */

const LOCAL_STORAGE_DISMISS_KEY = 'etm.survey-2021.dismiss-until';

/**
 * Translation helper.
 */
function t(key, options) {
  return I18n.t('survey.questions.' + key, options);
}

/**
 * Returns the elements used to answer a question.
 */
function renderQuestion(question, number, total) {
  const wrapper = $('<div />').addClass('question');
  const text = t(question.key + '.text', { defaults: [{ message: false }] });

  // Show current progress.
  if (number <= total) {
    wrapper.append(
      $('<div />')
        .addClass('progress')
        .text(I18n.t('survey.question_number', { num: number, total: total }))
    );
  }

  wrapper.append($('<h3 />').text(t(question.key + '.title')));

  if (text && text.length > 0) {
    wrapper.append($('<p />').text(text));
  }

  if (question.type === 'range') {
    wrapper.append(renderRangeQuestion(question));
  } else if (question.type == 'multiple_choice') {
    wrapper.append(renderMultipleChoiceQuestion(question));
  } else {
    wrapper.append(renderTextQuestion(question));
  }

  return wrapper;
}

/**
 * Renders the choices in a range (1-5) as emoji instead of numbers.
 */
function rangeEmojiIcon(question, choice) {
  return $('<img />')
    .attr('src', '/assets/survey/choice-' + choice + '.svg')
    .attr('alt', choice.toString())
    .attr('draggable', false)
    .attr('width', 64)
    .attr('height', 64);
}

function renderRangeQuestion(question) {
  const wrapper = $('<div />');

  // Show the legend which describes what each extreme means.
  wrapper.append(
    $('<div />')
      .addClass('range-legend')
      .append(
        $('<span />').text(t(question.key + '.min')),
        $('<span />').text(t(question.key + '.max'))
      )
  );

  // Show the options.
  wrapper.append(
    renderChoices(question, question.key === 'how_easy' ? rangeEmojiIcon : undefined).addClass(
      'range-question'
    )
  );

  return wrapper;
}

/**
 * Renders the icons used for multiple choice questions. Shows the icon and allows it to be
 * replaced with a check instead.
 */
function multipleChoiceIcon(question, choice) {
  return $('<span />')
    .addClass('icon-holder')
    .append(
      $('<img />')
        .attr('src', '/assets/survey/choice-' + choice.toString().replace(/_/g, '-') + '.svg')
        .attr('aria-hidden', true)
        .attr('draggable', false)
        .attr('width', 32)
        .attr('height', 32)
        .addClass('icon'),
      $('<img />')
        .attr('src', '/assets/survey/choice-checked.svg')
        .attr('aria-hidden', true)
        .attr('draggable', false)
        .attr('width', 32)
        .attr('height', 32)
        .addClass('checked')
    );
}

function renderMultipleChoiceQuestion(question) {
  return renderChoices(question, multipleChoiceIcon).addClass('multiple-choice-question');
}

/**
 * Renders multiple choices which are shown in a list.
 */
function renderChoices(question, contentFn) {
  const list = $('<ul />')
    .addClass('choices')
    .addClass('choices-' + question.key.toString().replace(/_/g, '-'));

  contentFn =
    contentFn ||
    function () {
      return [];
    };

  question.choices.forEach(function (choice) {
    const id = _.uniqueId('choice_');
    const isOther = choice === 'other';

    list.append(
      $('<li />')
        .addClass('choice-' + choice.toString().replace(/_/g, '-'))
        .append(
          $('<input />')
            .attr('type', 'radio')
            .attr('name', question.key)
            .attr('value', choice)
            .attr('id', id)
            .attr('tabindex', 1),

          $('<label />')
            .attr('for', id)
            .append([
              contentFn(question, choice),
              isOther &&
                $('<input />')
                  .addClass('other')
                  .attr('type', 'text')
                  .attr('name', 'other-value')
                  .attr(
                    'placeholder',
                    t(question.key + '.choices.' + choice, { defaults: [{ message: choice }] })
                  ),
              !isOther &&
                $('<span />')
                  .addClass('choice-content')
                  .text(
                    t(question.key + '.choices.' + choice, { defaults: [{ message: choice }] })
                  ),
            ])
        )
    );
  });

  return list;
}

function renderTextQuestion(question) {
  return $('<textarea />')
    .attr('name', question.key)
    .attr('maxlength', question.max_length)
    .attr('tabindex', 1)
    .attr('placeholder', I18n.t('survey.optional'));
}

/**
 * Renders a message introducing the survey.
 */
function renderHello(resume) {
  return $('<div class="question hello-content" />').append(
    $('<h3 />').append(
      $('<img src="/assets/survey/wave.svg" alt="" aria-hidden="true" height="32" width="32" />'),
      I18n.t('survey.hello')
    ),
    $('<p />').text(I18n.t(resume ? 'survey.intro_continue' : 'survey.intro')),
    $('<p />').append($('<hl />').text(I18n.t('survey.intro_promise')))
  );
}

/**
 * Replaces the "Sure" button with the "Next question" button. In fact this keeps the element but
 * changes the styles and text while fading the button out briefly so the user doesn't see the
 * change in content and width.
 */
function replaceSureButton(button) {
  button.css('opacity', 0);

  button[0].addEventListener(
    'transitionend',
    () => {
      button
        .removeClass('success')
        .css('opacity', '')
        .empty()
        .append(
          I18n.t('survey.next_question'),
          ' ',
          $('<span />').addClass('fa').addClass('fa-chevron-right'),
          $('<span />').addClass('fa').addClass('fa-chevron-right')
        );
    },
    { once: true }
  );
}

/**
 * The main survey view. Renders the survey, handles progression through each question, submits
 * the answers, and hides the survey when done or dismissed.
 */
class SurveyView extends Backbone.View {
  get className() {
    return 'survey';
  }

  get events() {
    return {
      'submit form': 'advance',
      'change form': 'onFormChange',
      'input textarea': 'onFormChange',
      'input input': 'onFormChange',
      'click button.dismiss': 'dismissTemporarily',
      'click button.dismiss-forever': 'dismissForever',
      'click .choice-other, click input.other': 'onClickOther',
      mouseenter: 'stopAttention',
      mouseleave: 'seekAttention',
    };
  }

  render({ wasHello } = { wasHello: false }) {
    const heightWrapper = this.$el.find('.height-wrapper');

    if (!this.isVisible) {
      return this.initialRender();
    }

    const question = this.currentQuestion();
    const questionEl = renderQuestion(question, this.currentPosition + 1, this.questionsLength());

    const oldQuestionEl = this.$el.find('.question');

    this.$el.find('form').attr('action', '/survey/' + question.key);

    // Set the button to be "Next question...". This will be "Sure" when coming from the hello page.
    const button = this.$el.find('button.next-question');

    if (wasHello) {
      replaceSureButton(button);
    }

    if (this.$el.find('.question').length > 0) {
      this.swapContent(oldQuestionEl, questionEl);
    } else {
      heightWrapper.append(questionEl);
      heightWrapper.css('height', questionEl.height());
    }

    this.isFinished() && this.triggerFinished();
    this.enableDisableButton();
  }

  /**
   * Submits an answer to the server and renders the next question.
   */
  advance(event) {
    event.preventDefault();

    const isHello = this.isHello();

    // Immediately remove all attention grabbing animation.
    this.$el.removeClass('attention').removeClass('hello');

    if (!isHello) {
      this.sendAnswer();
      this.currentQuestion().answered = true;
    }

    if (this.isFinished()) {
      // If the user entered some feedback on the final page, we animate the button to show that
      // it has been sent, then close the survey.
      if (this.answerValue()) {
        this.showFeedbackSent();
      } else {
        this.dismissForever();
      }

      return;
    }

    // Advance to the first unanswered question. Normally, but not always, question 0: if the user
    // started the survey previously, they may have answered some questions already.
    this.currentPosition = this.options.data.questions.findIndex((question) => !question.answered);

    this.render({ wasHello: isHello });
  }

  /**
   * Returns the answer value of the currently displayed question.
   */
  answerValue() {
    const question = this.currentQuestion();
    let value;

    if (!question) {
      // Finish page; return the value of the textarea.
      return this.$el.find('textarea').val();
    }

    this.$el
      .find('form')
      .serializeArray()
      .forEach(function (obj) {
        if (obj.name === question.key) {
          value = obj.value;
        }
      });

    if (value === 'other' && this.$el.find('input.other')) {
      value = this.$el.find('input.other').val() || value;
    }

    return value;
  }

  /**
   * Returns the first unanswered question, which will be shown to the user.
   */
  currentQuestion() {
    return this.options.data.questions[this.currentPosition];
  }

  dismissTemporarily() {
    // Dismiss for a day.
    this.sendDismiss(new Date(new Date().getTime() + 1000 * 3600 * 24));
  }

  dismissForever() {
    // Dismiss for ten years.
    this.sendDismiss(new Date(new Date().getTime() + 1000 * 3600 * 24 * 365 * 10));
  }

  /**
   * Enables and disables the "Next question" button when an answer has been selected for the
   * current question.
   */
  enableDisableButton() {
    if (this.isFinished()) {
      if (this.answerValue()) {
        this.$el.find('button.next-question').text(I18n.t('survey.send_feedback'));
      } else {
        this.$el.find('button.next-question').text(I18n.t('survey.close'));
      }
    }

    this.$el
      .find('button[type=submit]')
      .attr('disabled', !this.answerValue() && this.currentQuestion().type !== 'text');
  }

  /**
   * Sets up the View the first time it is rendered, including the "Hello" page.
   */
  initialRender() {
    this.currentPosition = -1;

    // Initial setup.
    this.$el.addClass('hello').attr('role', 'dialog').attr('aria-modal', 'true');

    this.$el.append(
      $('<button />')
        .attr('type', 'button')
        .addClass('close-button dismiss')
        .append(
          $('<img />')
            .attr('src', '/assets/survey/close.svg')
            .attr('draggable', 'false')
            .attr('height', 16)
            .attr('width', 16)
            .attr('alt', 'Close survey')
        )
    );

    const form = $('<form />').attr('method', 'post');
    const heightWrapper = $('<div />').addClass('height-wrapper');

    const helloContent = renderHello(this.options.data.questions.some((q) => q.answered));
    heightWrapper.append(helloContent);

    form.append(heightWrapper);

    form.append(
      $('<div />')
        .addClass('commit')
        .append(
          $('<div />')
            .addClass('dismiss-buttons')
            .append(
              $('<button />')
                .addClass('dismiss')
                .attr('type', 'button')
                .attr('tabindex', 3)
                .append(
                  $('<span />').addClass('fa').addClass('fa-history'),
                  I18n.t('survey.ask_me_later')
                ),
              $('<button />')
                .addClass('dismiss-forever')
                .attr('type', 'button')
                .attr('tabindex', 4)
                .append(
                  $('<span />').addClass('fa').addClass('fa-times'),
                  I18n.t('survey.never_ask_again')
                )
            ),
          $('<button />')
            .attr('type', 'submit')
            .attr('tabindex', 2)
            .addClass('button primary success next-question')
            .text(I18n.t('survey.sure'))
        )
    );

    this.$el.append(form);
    $('body').append(this.el);

    heightWrapper.css('height', helloContent.height());
    this.$el.addClass('entrance');

    this.el.addEventListener('animationend', () => {
      this.$el.removeClass('entrance').addClass('attention');
    });

    this.isVisible = true;
  }

  /**
   * Returns true if the user has answered all the questions.
   */
  isFinished() {
    return this.currentPosition >= this.questionsLength();
  }

  isHello() {
    return this.currentPosition < 0;
  }

  /**
   * Triggered whenever a change or input event is fired within the form.
   */
  onFormChange(event) {
    event.preventDefault();

    // Don't submit while user is typing, wait for them to finish.
    if (event.type !== 'input') {
      this.sendAnswer();
    }

    this.enableDisableButton();
  }

  /**
   * Triggered when selecting "Other" in a multiple choice question.
   * */
  onClickOther(event) {
    const label = event.target.closest('label');

    if (label) {
      event.preventDefault();

      label.closest('li').querySelector('input[type="radio"]').click();
      label.querySelector('input.other').focus();
    }
  }

  /**
   * The total number of questions, minus the final feedback page.
   */
  questionsLength() {
    return this.options.data.questions.length - 1;
  }

  /**
   * Starts wiggling the element for attention every 20 seconds when on the hello page.
   */
  seekAttention() {
    if (this.isHello() && !this.$el.hasClass('exiting')) {
      this.$el.addClass('attention');
    }
  }

  /**
   * Submits the selected answer to the server as soon as one is selected by the user.
   */
  sendAnswer() {
    const answerKey = this.currentPosition + '.' + this.answerValue();

    if (answerKey === this.lastAnswerKey) {
      // Don't send duplicate updates.
      return;
    }

    this.lastAnswerKey = answerKey;

    $.ajax({
      url: this.$el.find('form').attr('action'),
      method: 'PUT',
      dataType: 'json',
      data: { answer: this.answerValue() },
    });
  }

  sendDismiss(dismissUntil) {
    window.localStorage.setItem(LOCAL_STORAGE_DISMISS_KEY, JSON.stringify(dismissUntil));

    this.$el.removeClass('entrance');
    this.$el.removeClass('attention');

    // A short wait avoids the animation glitching when the survey just faded in. Using rAF twice
    // ensures it happens in the next frame, after the entrance/attention classes have been
    // removed.
    window.requestAnimationFrame(() => {
      window.requestAnimationFrame(() => {
        this.$el.addClass('exiting');

        this.el.addEventListener(
          'transitionend',
          (event) => {
            if (event.target === this.el) {
              this.el.remove();
            }
          },
          false
        );
      });
    });
  }

  showFeedbackSent() {
    const button = this.$el.find('button.finished');
    const sentEl = $('<span />')
      .addClass('levitate hide')
      .append($('<span class="fa fa-check"></span>'), ' ', I18n.t('survey.sent'));

    button.html('<span class="old-text">' + button.html() + '</span>');
    button.append(sentEl);

    window.requestAnimationFrame(function () {
      button.find('.old-text').addClass('hide').attr('disabled', true);
      sentEl.removeClass('hide');
    });

    window.setTimeout(this.dismissForever.bind(this), 3000);
  }

  /**
   * Stops wiggling the element for attention when the user's mouse is over the el.
   */
  stopAttention() {
    this.$el.removeClass('attention');
  }

  /**
   * Moves the old question out to the left, brings the new one in from the right.
   */
  swapContent(originalEl, newEl) {
    const heightWrapper = this.$el.find('.height-wrapper');

    // Exit old element to the left.
    originalEl.addClass('exit');

    // Bring in new element from the right.
    newEl.addClass('initial');
    heightWrapper.append(newEl);

    // Animated resize of wrapper element.
    heightWrapper.css('height', newEl.height());
    newEl.removeClass('initial');

    window.setTimeout(function () {
      originalEl.remove();
      newEl.find('input:first, textarea:first').trigger('focus');
    }, 500);
  }

  /**
   * Renders the "thanks!" text, and fades out the survey after a short period.
   */
  triggerFinished() {
    window.confetti({
      angle: 120,
      disableForReducedMotion: true,
      origin: { x: 1, y: 1 },
      particleCount: 75,
      startVelocity: 60,
      ticks: 300,
      zIndex: 1070,
    });

    this.$el.find('form').attr('action', '/survey/feedback');

    this.$el.find('.dismiss-buttons').css('opacity', 0).css('pointer-events', 'none');
    this.$el.find('button.next-question').addClass('success finished').text(I18n.t('survey.close'));

    // Reach into the scenario nav and remove the survey option.
    $('#scenario-nav .open-survey').remove();
  }
}

SurveyView.begin = function () {
  const dismissUntil = window.localStorage.getItem(LOCAL_STORAGE_DISMISS_KEY);

  if (dismissUntil && new Date(JSON.parse(dismissUntil)) > new Date()) {
    return;
  }

  if ($('body > .survey').length > 0) {
    return;
  }

  $(function () {
    const req = $.ajax({
      url: '/survey',
      method: 'GET',
      dataType: 'json',
    });

    req.done(function (data) {
      if ($('body > .survey').length > 0) {
        return;
      }

      if (!data.finished) {
        new SurveyView({ data: data }).render();
      }
    });
  });
};

export default SurveyView;
