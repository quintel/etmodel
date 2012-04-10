QUnit.specify('', function () {
    var wrapper = $('#slider'), slider;

    describe('stepUp', function () {
        var wrapper = $('#slider'), slider, dragRun, changeRun;

        after(function () {
            wrapper.html('');
        });

        describe('When step: 1', function () {
            before(function () {
                dragRun   = false;
                changeRun = false;

                slider = new $.Quinn(wrapper, {
                    drag:   function () { dragRun   = true },
                    change: function () { changeRun = true },
                });
            });

            it('should increment the slider value by 1', function () {
                assert(slider.stepUp()).equals(1);
                assert(slider.model.value).equals(1);
            });

            it('should increment by multiples of the step', function () {
                assert(slider.stepUp(2)).equals(2);
                assert(slider.model.value).equals(2);
            });

            it('should run drag', function () {
                slider.stepUp();
                assert(dragRun).isTrue();
            });

            it('should run change', function () {
                slider.stepUp();
                assert(changeRun).isTrue();
            });
        });

        describe('When step: 10', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { step: 10 });
            });

            it('should increment the slider value by 10', function () {
                assert(slider.stepUp()).equals(10);
                assert(slider.model.value).equals(10);
            });

            it('should increment by multiples of the step', function () {
                assert(slider.stepUp(2)).equals(20);
                assert(slider.model.value).equals(20);
            });
        });

        describe('When already at maximum value', function () {
            before(function () {
                dragRun   = false;
                changeRun = false;

                slider = new $.Quinn(wrapper, { value: 100 });
            });

            it('should not change the slider value', function () {
                assert(slider.stepUp()).equals(100);
                assert(slider.model.value).equals(100);
            });

            it('should not run drag', function () {
                slider.stepUp();
                assert(dragRun).isFalse();
            });

            it('should not run change', function () {
                slider.stepUp();
                assert(changeRun).isFalse();
            });
        });

        describe('When nearly at maximum value', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: 99 });
            });

            it('should not change the slider value', function () {
                assert(slider.stepUp(2)).equals(100);
                assert(slider.model.value).equals(100);
            });
        });

        describe('when the slider is disabled', function () {
            before(function () {
                dragRun   = false;
                changeRun = false;

                slider = new $.Quinn(wrapper, { disable: true });
            });

            it('should not change the slider value', function () {
                assert(slider.stepUp()).equals(0);
                assert(slider.model.value).equals(0);
            });

            it('should not run drag', function () {
                slider.stepUp();
                assert(dragRun).isFalse();
            });

            it('should not run change', function () {
                slider.stepUp();
                assert(changeRun).isFalse();
            });
        });

        describe('when using a range-based slider', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: [25, 75] });
            });

            it('should return the original value', function () {
                var originalValue = _.clone(slider.model.value),
                    equality = _.isEqual(slider.stepUp(), originalValue);

                assert(equality).isTrue();
            });

            it('should not change the value', function () {
                var originalValue = _.clone(slider.model.value);

                slider.stepUp()
                assert(_.isEqual(slider.model.value, originalValue)).isTrue();
            });
        });
    });

    describe('stepDown', function () {
        var wrapper = $('#slider'), slider, dragRun, changeRun;

        after(function () {
            wrapper.html('');
        });

        describe('When step: 1', function () {
            before(function () {
                dragRun   = false;
                changeRun = false;

                slider = new $.Quinn(wrapper, {
                    value:    100,
                    drag:   function () { dragRun   = true },
                    change: function () { changeRun = true },
                });
            });

            it('should decrement the slider value by 1', function () {
                assert(slider.stepDown()).equals(99);
                assert(slider.model.value).equals(99);
            });

            it('should increment by multiples of the step', function () {
                assert(slider.stepDown(2)).equals(98);
                assert(slider.model.value).equals(98);
            });

            it('should run drag', function () {
                slider.stepDown();
                assert(dragRun).isTrue();
            });

            it('should run change', function () {
                slider.stepDown();
                assert(changeRun).isTrue();
            });
        });

        describe('When step: 10', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: 100, step: 10 });
            });

            it('should increment the slider value by 10', function () {
                assert(slider.stepDown()).equals(90);
                assert(slider.model.value).equals(90);
            });

            it('should increment by multiples of the step', function () {
                assert(slider.stepDown(2)).equals(80);
                assert(slider.model.value).equals(80);
            });
        });

        describe('When already at minumum value', function () {
            before(function () {
                dragRun   = false;
                changeRun = false;

                slider = new $.Quinn(wrapper);
            });

            it('should not change the slider value', function () {
                assert(slider.stepDown()).equals(0);
                assert(slider.model.value).equals(0);
            });

            it('should not run drag', function () {
                slider.stepDown();
                assert(dragRun).isFalse();
            });

            it('should not run change', function () {
                slider.stepDown();
                assert(changeRun).isFalse();
            });
        });

        describe('When nearly at minimum value', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: 1 });
            });

            it('should not change the slider value', function () {
                assert(slider.stepDown(2)).equals(0);
                assert(slider.model.value).equals(0);
            });
        });

        describe('when the slider is disabled', function () {
            before(function () {
                dragRun   = false;
                changeRun = false;

                slider = new $.Quinn(wrapper, { value: 100, disable: true });
            });

            it('should not change the slider value', function () {
                assert(slider.stepDown()).equals(100);
                assert(slider.model.value).equals(100);
            });

            it('should not run drag', function () {
                slider.stepDown();
                assert(dragRun).isFalse();
            });

            it('should not run change', function () {
                slider.stepDown();
                assert(changeRun).isFalse();
            });
        });

        describe('when using a range-based slider', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: [25, 75] });
            });

            it('should return the original value', function () {
                var originalValue = _.clone(slider.model.value),
                    equality = _.isEqual(slider.stepDown(), originalValue);

                assert(equality).isTrue();
            });

            it('should not change the value', function () {
                var originalValue = _.clone(slider.model.value);

                slider.stepDown()
                assert(_.isEqual(slider.model.value, originalValue)).isTrue();
            });
        });
    });

});
