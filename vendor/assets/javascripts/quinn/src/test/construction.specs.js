QUnit.specify('', function () {

    describe('Constructor', function () {
        var wrapper = $('#slider'), slider;

        after(function () {
            wrapper.html('');
        });

        describe('With default settings', function () {
            before(function () {
                slider = new $.Quinn(wrapper);
            });

            it('should set the  value to 0', function () {
                assert(slider.model.value).equals(0);
            });

            it('should set the left drawTo value to 0', function () {
                assert(slider.drawTo.left).equals(0);
            });

            it('should set the right drawTo value to 100', function () {
                assert(slider.drawTo.right).equals(100);
            });

            it('should set the minimum value to 0', function () {
                assert(slider.model.minimum).equals(0);
            });

            it('should set the maximum value to 100', function () {
                assert(slider.model.maximum).equals(100);
            });

            it('should not be disabled', function () {
                assert(slider.disabled).isFalse();
            });
        }); // With default settings

        describe('With min: 20, max: 40', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { min: 20, max: 40 });
            });

            it('should set the value to 20', function () {
                assert(slider.model.value).equals(20);
            });

            it('should set the left drawTo value to 20', function () {
                assert(slider.drawTo.left).equals(20);
            });

            it('should set the right drawTo value to 40', function () {
                assert(slider.drawTo.right).equals(40);
            });

            it('should set the minimum value to 20', function () {
                assert(slider.model.minimum).equals(20);
            });

            it('should set the maximum value to 40', function () {
                assert(slider.model.maximum).equals(40);
            });
        }); // With min: 20, max: 40

        describe('With drawTo: { left: -100, right: 200 }', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { drawTo: { left: -100, right: 200 } });
            });

            it('should set the value to 0', function () {
                assert(slider.model.value).equals(0);
            });

            it('should set the left drawTo value to -100', function () {
                assert(slider.drawTo.left).equals(-100);
            });

            it('should set the right drawTo value to 200', function () {
                assert(slider.drawTo.right).equals(200);
            });

            it('should set the minimum value to 0', function () {
                assert(slider.model.minimum).equals(0);
            });

            it('should set the maximum value to 100', function () {
                assert(slider.model.maximum).equals(100);
            });
        }); // With drawTo { left: -100, right: 200 }

        describe('With drawTo: { left: -100 }', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { drawTo: { left: -100 } });
            });

            it('should set the value to 0', function () {
                assert(slider.model.value).equals(0);
            });

            it('should set the left drawTo value to -100', function () {
                assert(slider.drawTo.left).equals(-100);
            });

            it('should set the right drawTo value to 100', function () {
                assert(slider.drawTo.right).equals(100);
            });

            it('should set the minimum value to 0', function () {
                assert(slider.model.minimum).equals(0);
            });

            it('should set the maximum value to 100', function () {
                assert(slider.model.maximum).equals(100);
            });
        }); // With drawTo { left: -100 }

        describe('With drawTo: { right: 200 }', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { drawTo: { right: 200 } });
            });

            it('should set the value to 0', function () {
                assert(slider.model.value).equals(0);
            });

            it('should set the left drawTo value to 100', function () {
                assert(slider.drawTo.left).equals(0);
            });

            it('should set the right drawTo value to 200', function () {
                assert(slider.drawTo.right).equals(200);
            });

            it('should set the minimum value to 0', function () {
                assert(slider.model.minimum).equals(0);
            });

            it('should set the maximum value to 100', function () {
                assert(slider.model.maximum).equals(100);
            });
        }); // With drawTo { right: 200 }

        describe('With step: 15', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { step: 15 });
            });

            it('should set the value to 0', function () {
                assert(slider.model.value).equals(0);
            });

            it('should set the left drawTo value to 0', function () {
                assert(slider.drawTo.left).equals(0);
            });

            it('should set the right drawTo value to 100', function () {
                assert(slider.drawTo.right).equals(100);
            });

            it('should set the minimum value to 0', function () {
                assert(slider.model.minimum).equals(0);
            });

            it('should set the maximum value to 90', function () {
                // 100 isn't divisible by the step.
                assert(slider.model.maximum).equals(90);
            });
        }); // With step: 15

        describe('With step: 10, strict: false', function () {
          function steppedSlider (value) {
            return new $.Quinn(wrapper, {
              value: value, step: 10, strict: false
            });
          }

          it('should permit a starting value of 0', function () {
              var slider = steppedSlider(0);
              assert(slider.model.value).equals(0);
          });

          it('should permit a starting value of 5.5', function () {
              var slider = steppedSlider(5.5);
              assert(slider.model.value).equals(5.5);
          });

          it('should permit a starting value of 10', function () {
              var slider = steppedSlider(10);
              assert(slider.model.value).equals(10);
          });

          it('should not permit a starting value of -1', function () {
              var slider = steppedSlider(-1);
              assert(slider.model.value).equals(0);
          });

          it('should not permit a starting value of 101', function () {
              var slider = steppedSlider(101);
              assert(slider.model.value).equals(100);
          });
        }); // With step: 10, strict: false

        describe('With value: 50', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: 50 });
            });

            it('should set the value to 50', function () {
                assert(slider.model.value).equals(50);
            });
        }); // With value: 50

        describe('With value: -1', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: -1 });
            });

            it('should set the value to 0', function () {
                assert(slider.model.value).equals(0);
            });
        }); // With value: -1

        describe('With value: 500', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { value: 500 });
            });

            it('should set the value to 100', function () {
                assert(slider.model.value).equals(100);
            });
        }); // With value: 500

        describe('With disable: true', function () {
            before(function () {
                slider = new $.Quinn(wrapper, { disable: true });
            });

            it('should disable the slider', function () {
                assert(slider.disabled).isTrue();
            });
        }); // With disable: true

        describe('With setup: ...', function () {
            var callbackRun;

            before(function () {
                callbackRun = false;

                slider = new $.Quinn(wrapper, {
                    setup: function () {
                        callbackRun = true;
                    }
                });
            });

            it('should run the callback function', function () {
                assert(callbackRun).isTrue();
            });
        }); // With setup: ...

    });

});
