String.prototype.toFormulaDecimal = function () {
    var split = this.split('.');
    return split[0].replace(/[^\d.]*/gi, '').replace(/\B(?=(\d{3})+(?!\d))/g, ",") + (typeof split[1] !== 'undefined' ? '.' + split[1].replace(/[^\d.]*/gi, '') : '');
};

String.prototype.toFormulaString = function (shift) {
    var keyCode = parseInt(this);
    if (keyCode === 106) {
        return 'x';
    } else if (((keyCode === 187 || keyCode === 61) && shift === true) || keyCode === 107) {
        return '+';
    } else if (keyCode === 189 || keyCode === 173 || keyCode === 109) {
        return '-';
    } else if (keyCode === 190 || keyCode === 110) {
        return '.';
    } else if (keyCode === 191 || keyCode === 111) {
        return '/';
    } else {
        return String.fromCharCode(keyCode);
    }
};

(function ($) {
    var _PLUGIN_VERSION_ = '2.0.12';

    $.fn.formula = function (opt) {
        var _opt = {
            id: 'formula',
            cursorAnimTime: 160,
            cursorDelayTime: 500,
            strings: {
                formula: 'Formula',
                validationError: 'Validation Error',
                validationPassed: 'Passed'
            },
            import: {
                item: null,
            },
            export: {
                filter: function (data) {
                    var filterData = data;
                    return filterData;
                },
                item: function (e) {
                    return e.data('value') !== 'undefined' && e.data('value') !== null ? e.data('value') : e.text();
                }
            }
        };

        var _args = arguments;
        $.extend(_opt, opt);

        return this.each(function () {
            var $this = $(this);

            $this.data('formula', this);

            this.init = function () {
                var context = this;

                var drag = false, move = false, offset = null;
                context.container = $(context).addClass(context.opt.id + '-container');
                context.container.wrap('<div class="' + context.opt.id + '-wrapper"></div>');

                context.alert = $('<div class="' + context.opt.id + '-alert">' + _opt.strings.formula + '</div>');
                context.alert.insertBefore(context.container);

                context.text = $('<textarea id="' + context.opt.id + '-text" name="' + context.opt.id + '-text" class="' + context.opt.id + '-text"></textarea>');
                context.text.insertAfter(context.container).focus();
                context.text.bind('blur', function () {
                    if (context.cursor !== null) {
                        context.cursor.remove();
                        context.destroyDrag();
                    }
                });

                context.text.unbind('dblclick.' + context.opt.id + 'Handler').bind('dblclick.' + context.opt.id + 'Handler', function (event) {
                    context.selectAll();
                });

                context.text.unbind('mousedown.' + context.opt.id + 'Handler').bind('mousedown.' + context.opt.id + 'Handler', function (event) {
                    drag = true;

                    offset = {
                        x: event.offsetX,
                        y: event.offsetY
                    };
                });

                context.text.unbind('mouseup.' + context.opt.id + 'Handler').bind('mouseup.' + context.opt.id + 'Handler', function (event) {
                    drag = false;
                    if (move === true) {
                        move = false;
                    } else {
                        context.click({
                            x: event.offsetX,
                            y: event.offsetY
                        });
                    }
                });

                var startIndex;
                context.text.unbind('mousemove.' + context.opt.id + 'Handler').bind('mousemove.' + context.opt.id + 'Handler', function (event) {
                    if (drag === false) {
                        return true;
                    }

                    if (Math.abs(offset.x - event.offsetX) <= 5 && Math.abs(offset.y - event.offsetY) <= 5) {
                        return true;
                    }

                    if (context.container.hasClass('formula-active')) {
                        context.click({
                            x: event.offsetX,
                            y: event.offsetY
                        });
                    }

                    move = true;
                    if (context.container.find('.' + context.opt.id + '-drag').length > 0) {
                        var endIndex = 0;
                        context.destroyDrag();
                        context.click({
                            x: event.offsetX,
                            y: event.offsetY
                        });
                        endIndex = context.cursor.index();

                        $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                        var start = 0, end = 0;
                        if (startIndex > endIndex) {
                            end = startIndex;
                            start = endIndex;
                            $drag.insertBefore(context.cursor);
                        } else {
                            start = startIndex;
                            end = endIndex;
                            $drag.insertAfter(context.cursor);
                        }

                        if (start === end) {
                            return true;
                        }

                        context.container.children(':not(".' + context.opt.id + '-cursor")').filter(':gt("' + start + '")').filter(':lt("' + (end - start) + '")')
                        .add(context.container.children(':not(".' + context.opt.id + '-cursor")').eq(start)).each(function () {
                            var $this = $(this);
                            $this.appendTo($drag);
                        });

                        if (startIndex > endIndex) {
                            $drag.insertAfter(context.cursor);
                        } else {
                            $drag.insertBefore(context.cursor);
                        }
                    } else {
                        context.destroyDrag();
                        context.click({
                            x: event.offsetX,
                            y: event.offsetY
                        });
                        startIndex = context.cursor.index();

                        $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                        $drag.insertAfter(context.cursor);
                    }
                });

                context.text.unbind('keydown.' + context.opt.id + 'Handler').bind('keydown.' + context.opt.id + 'Handler', function (event) {
                    event.preventDefault();
                    var $drag, $prev, $next, $item, $dragItem, text, parentPadding;

                    if (context.cursor !== null && context.cursor.length > 0) {
                        var keyCode = event.which;
                        if (keyCode === 116 || (keyCode === 82 && event.ctrlKey)) {
                            location.reload();
                        } else if (keyCode === 65 && event.ctrlKey) {
                            context.selectAll();
                        } else if (keyCode >= 96 && keyCode <= 105) {
                            keyCode -= 48;
                        } else if (keyCode === 8) {
                            $drag = context.container.find('.' + context.opt.id + '-drag');
                            if ($drag.length > 0) {
                                context.cursor.insertBefore($drag);
                                $drag.remove();
                            } else if (context.cursor.length > 0 && context.cursor.prev().length > 0) {
                                $prev = context.cursor.prev();
                                if ($prev.hasClass(context.opt.id + '-unit') && $prev.text().length > 1) {
                                    text = $prev.text();
                                    context.setDecimal($prev, text.substring(0, text.length - 1).toFormulaDecimal());
                                } else {
                                    $prev.remove();
                                }
                            }
                            context.syntaxCheck();
                            $this.triggerHandler('formula.input', context.getFormula());
                            return false;
                        } else if (keyCode === 46) {
                            $drag = context.container.find('.' + context.opt.id + '-drag');
                            if ($drag.length > 0) {
                                context.cursor.insertAfter($drag);
                                $drag.remove();
                            } else {
                                if (context.cursor.length > 0 && context.cursor.next().length > 0) {
                                    $next = context.cursor.next();
                                    if ($next.hasClass(context.opt.id + '-unit') && $next.text().length > 1) {
                                        text = $next.text();
                                        context.setDecimal($next, text.substring(1, text.length).toFormulaDecimal());
                                    } else {
                                        $next.remove();
                                    }
                                }
                            }
                            context.syntaxCheck();
                            $this.triggerHandler('formula.input', context.getFormula());
                            return false;
                        } else if (keyCode >= 37 && keyCode <= 40) {
                            if (keyCode === 37) {
                                if (context.cursor.length > 0 && context.cursor.prev().length > 0) {
                                    if (event.shiftKey) {
                                        $drag = context.container.find('.' + context.opt.id + '-drag');
                                        if ($drag.length < 1) {
                                            $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                            $drag.insertAfter(context.cursor);
                                        } else {
                                            if ($drag.data('active') === false) {
                                                context.destroyDrag();
                                                $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                                $drag.insertAfter(context.cursor);
                                            }
                                        }
                                        $drag.data('active', true);

                                        $prev = context.cursor.prev();
                                        if ($prev.hasClass(context.opt.id + '-drag')) {
                                            $dragItem = $drag.children('*');
                                            if ($dragItem.length < 1) {
                                                $drag.remove();
                                            } else {
                                                $dragItem.last().insertAfter($drag);
                                                context.cursor.insertAfter($drag);
                                            }
                                        } else {
                                            context.cursor.prev().prependTo($drag);
                                        }
                                    } else {
                                        context.destroyDrag();
                                        context.cursor.insertBefore(context.cursor.prev());
                                    }
                                } else {
                                    context.destroyDrag();
                                }
                            } else if (keyCode === 38) {
                                if (context.cursor.prev().length > 0 || context.cursor.next().length > 0) {
                                    parentPadding = {
                                        x: parseFloat(context.container.css('padding-left').replace(/[^\d.]/gi, '')),
                                        y: parseFloat(context.container.css('padding-top').replace(/[^\d.]/gi, ''))
                                    };

                                    $item = context.cursor.prev();
                                    if ($item.length < 0) {
                                        $item = context.cursor.next();
                                    }
                                    context.click({
                                        x: context.cursor.position().left + $item.outerWidth(),
                                        y: context.cursor.position().top - $item.outerHeight() / 2
                                    });
                                } else {

                                }
                            } else if (keyCode === 39) {
                                if (context.cursor.length > 0 && context.cursor.next().length > 0) {
                                    if (event.shiftKey) {
                                        $drag = context.container.find('.' + context.opt.id + '-drag');
                                        if ($drag.length < 1) {
                                            $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                            $drag.insertBefore(context.cursor);
                                        } else {
                                            if ($drag.data('active') === false) {
                                                context.destroyDrag();
                                                $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                                $drag.insertBefore(context.cursor);
                                            }
                                        }
                                        $drag.data('active', true);

                                        $next = context.cursor.next();
                                        if ($next.hasClass(context.opt.id + '-drag')) {
                                            $dragItem = $drag.children('*');
                                            if ($dragItem.length < 1) {
                                                $drag.remove();
                                            } else {
                                                $dragItem.first().insertBefore($drag);
                                                context.cursor.insertBefore($drag);
                                            }
                                        } else {
                                            context.cursor.next().appendTo($drag);
                                        }
                                    } else {
                                        context.destroyDrag();
                                        context.cursor.insertAfter(context.cursor.next());
                                    }
                                } else {
                                    context.destroyDrag();
                                }
                            } else if (keyCode === 40) {
                                if (context.cursor.prev().length > 0 || context.cursor.next().length > 0) {
                                    parentPadding = {
                                        x: parseFloat(context.container.css('padding-left').replace(/[^\d.]/gi, '')),
                                        y: parseFloat(context.container.css('padding-top').replace(/[^\d.]/gi, ''))
                                    };

                                    $item = context.cursor.prev();
                                    if ($item.length < 0) {
                                        $item = context.cursor.next();
                                    }
                                    context.click({
                                        x: context.cursor.position().left + $item.outerWidth(),
                                        y: context.cursor.position().top + $item.outerHeight() * 1.5
                                    });
                                } else {

                                }
                            }
                            return false;
                        } else if (keyCode === 35 || keyCode === 36) {
                            if (keyCode === 35) {
                                if (context.cursor.length > 0 && context.container.children(':last').length > 0) {
                                    if (event.shiftKey) {
                                        $drag = context.container.find('.' + context.opt.id + '-drag');
                                        if ($drag.length < 1) {
                                            $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                            $drag.insertBefore(context.cursor);
                                        } else {
                                            if ($drag.data('active') === false) {
                                                context.destroyDrag();
                                                $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                                $drag.insertBefore(context.cursor);
                                            }
                                        }
                                        $drag.data('active', true);
                                        context.cursor.nextAll().appendTo($drag);
                                    } else {
                                        context.destroyDrag();
                                        context.cursor.insertAfter(context.container.children(':last'));
                                    }
                                }
                            } else if (keyCode === 36) {
                                if (context.cursor.length > 0 && context.container.children(':first').length > 0) {
                                    if (event.shiftKey) {
                                        $drag = context.container.find('.' + context.opt.id + '-drag');
                                        if ($drag.length < 1) {
                                            $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                            $drag.insertAfter(context.cursor);
                                        } else {
                                            if ($drag.data('active') === false) {
                                                context.destroyDrag();
                                                $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                                                $drag.insertAfter(context.cursor);
                                            }
                                        }
                                        $drag.data('active', true);
                                        context.cursor.prevAll().each(function () {
                                            var $this = $(this);
                                            $this.prependTo($drag);
                                        });
                                    } else {
                                        context.destroyDrag();
                                        context.cursor.insertBefore(context.container.children(':first'));
                                    }
                                }
                            } else {
                                return false;
                            }
                        } else if ((keyCode >= 48 && keyCode <= 57) === false &&
                                  (keyCode !== 88 && keyCode !== 187 && keyCode !== 189 && keyCode !== 190 && keyCode !== 191) === true) {
                            return false;
                        }

                        context.keydown(keyCode.toString().toFormulaString(event.shiftKey), event.shiftKey);
                        context.syntaxCheck();
                    }
                });
            };

            this.syntaxCheck = function (callback) {
                var context = this;

                var formula = context.getFormula().data;

                if (typeof formula !== 'undefined') {
                    var result = new FormulaParser(formula);
                    if (result.status === true) {
                        context.alert.text(context.opt.strings.validationPassed).addClass(context.opt.id + '-alert-good').removeClass(context.opt.id + '-alert-error');
                        if (typeof callback === 'function') {
                            callback(true);
                        }
                        return true;
                    }
                    else {
                        context.alert.text(context.opt.strings.validationError).removeClass(context.opt.id + '-alert-good').addClass(context.opt.id + '-alert-error');
                        if (typeof callback === 'function') {
                            callback(false);
                        }
                        return false;
                    }
                }
            };

            this.destroyDrag = function () {
                var context = this;

                var $drag = context.container.find('.' + context.opt.id + '-drag');
                $drag.children('*').each(function () {
                    var $this = $(this);
                    $this.insertBefore($drag);
                });
                $drag.remove();
                $this.triggerHandler('formula.input', context.getFormula());
            };

            this.selectAll = function () {
                var context = this;

                context.destroyDrag();
                $drag = $('<div class="' + context.opt.id + '-drag"></div>');
                $drag.prependTo(context.container);
                context.container.children(':not(".' + context.opt.id + '-cursor")').each(function () {
                    var $this = $(this);
                    $this.appendTo($drag);
                });
            };

            this.click = function (position) {
                var context = this;

                context.container.find('.' + context.opt.id + '-cursor').remove();

                var $cursor = $('<div class="' + context.opt.id + '-cursor"></div>');
                var check = null, idx = null;
                position = position || { x: 0, y: 0 };
                $cursor.appendTo(context.container);
                context.cursor = $cursor;

                var parentPos = {
                    x: context.container.offset().left,
                    y: context.container.offset().top
                };

                var parentPadding = {
                    x: parseFloat(context.container.css('padding-left').replace(/[^\d.]/gi, '')),
                    y: parseFloat(context.container.css('padding-top').replace(/[^\d.]/gi, ''))
                };

                var checkArea = [];

                context.container.children('*:not(".' + context.opt.id + '-cursor")').each(function () {
                    var $this = $(this);
                    checkArea.push({
                        x: $this.offset().left - parentPos.x + parentPadding.x,
                        y: $this.offset().top - parentPos.y,
                        e: $this
                    });
                });


                var $pointer = null;
                var maxY = 0, maxDiff = 10000;
                for (idx in checkArea) {
                    check = checkArea[idx];
                    if (check.y <= position.y) {
                        if (check.y >= maxY * 0.5 && check.x <= position.x) {
                            if (check.y >= maxY) {
                                maxY = check.y;
                            }
                            if (position.x - check.x <= maxDiff) {
                                maxDiff = position.x - check.x;
                                $pointer = check.e;
                            }
                        }
                    }
                }

                if ($pointer === null) {
                    maxY = 0;
                    maxDiff = 10000;
                    for (idx in checkArea) {
                        check = checkArea[idx];
                        if (check.y >= maxY * 0.5 && check.x <= position.x) {
                            if (check.y >= maxY) {
                                maxY = check.y;
                            }
                            if (position.x - check.x < maxDiff) {
                                maxDiff = position.x - check.x;
                                $pointer = check.e;
                            }
                        }
                    }
                }

                if (checkArea.length > 0 && $pointer !== null && maxY + checkArea[0].e.outerHeight() >= position.y) {
                    context.cursor.insertAfter($pointer);
                } else {
                    if (checkArea.length > 0 && position.x > checkArea[0].x) {
                        context.cursor.appendTo(context.container);
                    } else {
                        context.cursor.prependTo(context.container);
                    }
                }

                var loop = function () {
                    setTimeout(function () {
                        if ($cursor.hasClass('inactive')) {
                            $cursor.removeClass('inactive');
                            $cursor.stop().animate({ opacity: 1 }, context.opt.cursorAnimTime);
                        } else {
                            $cursor.addClass('inactive');
                            $cursor.stop().animate({ opacity: 0 }, context.opt.cursorAnimTime);
                        }

                        if ($cursor.length > 0) {
                            loop();
                        }
                    }, context.opt.cursorDelayTime);
                };
                loop();

                context.destroyDrag();
            };

            this.keydown = function (key, shift) {
                var context = this;

                var convert = {
                    0: ')',
                    1: '!',
                    2: '@',
                    3: '#',
                    4: '$',
                    5: '%',
                    6: '^',
                    7: '&',
                    8: 'x',
                    9: '('
                };

                if (shift && (key >= 0 && key <= 9)) {
                    key = convert[key];
                }
                key = $.trim(key);

                context.insertChar.call(context, key);
            };

            this.insert = function (item, position) {
                var context = this;

                if (context.cursor === null || context.cursor.length < 1 || typeof position === 'object') {
                    context.click(position);
                }

                if (typeof item === 'string') {
                    item = $(item);
                }

                item.addClass(context.opt.id + '-item');
                item.insertBefore(context.cursor);

                context.text.focus();
                context.syntaxCheck();

                $this.triggerHandler('formula.input', context.getFormula());
            };

            this.insertChar = function (key) {
                var context = this;

                if ((key >= 0 && key <= 9) || $.inArray(key.toLowerCase(), context.permitedKey) != -1) {
                    if ((key >= 0 && key <= 9) || key === '.') {
                        var $unit = $('<div class="' + context.opt.id + '-item ' + context.opt.id + '-unit">' + key + '</div>');
                        var $item = null;
                        var decimal = '', merge = false;

                        $drag = context.container.find('.' + context.opt.id + '-drag');

                        if ($drag.length > 0) {
                            context.cursor.insertBefore($drag);
                            $drag.remove();
                        }

                        if (context.cursor !== null && context.cursor.length > 0) {
                            context.cursor.before($unit);
                        } else {
                            context.container.append($unit);
                        }

                        var $prev = $unit.prev();
                        var $next = $unit.next();

                        if ($prev.length > 0 && $prev.hasClass(context.opt.id + '-cursor')) {
                            $prev = $prev.prev();
                        }

                        if ($next.length > 0 && $next.hasClass(context.opt.id + '-cursor')) {
                            $next = $next.next();
                        }

                        if ($prev.length > 0 && $prev.hasClass(context.opt.id + '-unit')) {
                            merge = true;
                            $item = $prev;
                            $item.append($unit[0].innerHTML);
                        } else if ($next.length > 0 && $next.hasClass(context.opt.id + '-unit')) {
                            merge = true;
                            $item = $next;
                            $item.prepend($unit[0].innerHTML);
                        }

                        if (merge === true) {
                            decimal = $item.text().toFormulaDecimal();
                            context.setDecimal($item, decimal);
                            $unit.remove();
                        }
                    } else if (key !== '') {
                        var $operator = $('<div class="' + context.opt.id + '-item ' + context.opt.id + '-operator">' + key.toLowerCase() + '</div>');
                        if (context.cursor !== null && context.cursor.length > 0) {
                            context.cursor.before($operator);
                        } else {
                            context.container.append($operator);
                        }
                        if (key === '(' || key === ')') {
                            $operator.addClass(context.opt.id + '-bracket');
                        }
                    }

                    $this.triggerHandler('formula.input', context.getFormula());
                }
            };

            this.insertFormula = function (data) {
                var context = this;
                var idx = 0;

                if (typeof data === 'string') {
                    var data_split = data.split('');
                    for (idx in data_split) {
                        context.insertChar.call(context, data_split[idx]);
                    }
                } else {
                    for (idx in data) {
                        var item = data[idx];
                        if (typeof item !== 'object') {
                            var data_splited = item.toString().split('');
                            for (var key in data_splited) {
                                context.insertChar.call(context, data_splited[key]);
                            }
                        } else {
                            if (typeof context.opt.import.item === 'function') {
                                var $e = context.opt.import.item.call(context, item);
                                if (typeof $e !== 'undefined' && $e !== null) {
                                    context.insert($e);
                                }
                            }
                        }
                    }
                }
                context.syntaxCheck();

                $this.triggerHandler('formula.input', context.getFormula());
            };

            this.empty = function () {
                var context = this;

                context.container.find(':not(".' + context.opt.id + '-cursor")').remove();
                $this.triggerHandler('formula.input', context.getFormula());

                return context.container;
            };

            this.setDecimal = function (element, decimal) {
                var context = this;

                if (decimal !== '') {
                    element.empty();
                    var split = decimal.split('.');
                    var $prefix = $('<span class="' + context.opt.id + '-prefix ' + context.opt.id + '-decimal-highlight">' + split[0] + '</span>');
                    $prefix.appendTo(element);

                    if (typeof split[1] !== 'undefined') {
                        var $surfix = $('<span class="' + context.opt.id + '-surfix ' + context.opt.id + '-decimal-highlight">.' + split[1] + '</span>');
                        $surfix.appendTo(element);
                    }
                }
            };

            this.setFormula = function (data) {
                var context = this;

                context.empty();
                try {
                    var obj = null;
                    if (typeof data !== 'object') {
                        obj = JSON.parse(data);
                    } else {
                        obj = data;
                    }

                    var decodedData = new FormulaParser(obj);
                    if (decodedData.status === true) {
                        context.insertFormula.call(context, decodedData.data);
                    }
                } catch (e) {
                    console.trace(e.stack);
                }
            };

            this.getFormula = function (callback) {
                var context = this;

                var data = [];
                var filterData = null;
                var result;

                if (typeof context.opt.export.filter === 'function') {
                    context.container.find('.formula-item').each(function () {
                        var $this = $(this);
                        var item = {};
                        item.value = ($this.data('value') ? $this.data('value') : $this.text());

                        if ($this.hasClass(context.opt.id + '-unit')) {
                            item.type = 'unit';
                            item.value = item.value.toFormulaDecimal();
                        } else if ($this.hasClass(context.opt.id + '-custom')) {
                            item.type = 'item';
                            if (typeof context.opt.export !== 'undefined' && typeof context.opt.export.item === 'function') {
                                try {
                                    item.value = context.opt.export.item.call(context, $this);
                                } catch (e) {
                                    item.value = '0';
                                }
                            } else {
                                item.value = '0';
                            }
                        } else if ($this.hasClass(context.opt.id + '-operator')) {
                            item = item.value === 'x' ? '*' : item.value;
                        }
                        data.push(item);
                    });

                    data = data;
                    filterData = new FormulaParser(Object.assign([], data));
                    filterData.data = context.opt.export.filter(filterData.data);

                    result = {
                        data: data,
                        filterData: filterData
                    };
                } else {
                    context.container.find('.formula-item').each(function () {
                        var $this = $(this);
                        var value = ($this.data('value') ? $this.data('value') : $this.text());
                        if ($this.hasClass(context.opt.id + '-unit')) {
                            value = value.toFormulaDecimal();
                        } else if ($this.hasClass(context.opt.id + '-operator') && value === 'x') {
                            value = '*';
                        } else if ($this.hasClass(context.opt.id + '-custom')) {
                            if (typeof context.opt.export !== 'undefined' && typeof context.opt.export.item === 'function') {
                                try {
                                    value = context.opt.export.call(context, $this);
                                } catch (e) {
                                    value = '0';
                                }
                            } else {
                                value = '0';
                            }
                        }
                        data.push(value);
                    });

                    result = {
                        data: data.join(' '),
                        filterData: filterData
                    };
                }

                if (typeof callback === 'function') {
                    callback(result);
                }

                return result;
            };

            if (_args.length < 1 || typeof _args[0] === 'object') {
                this.alert = null;
                this.text = null;
                this.container = null;
                this.cursor = null;
                this.opt = _opt;
                this.permitedKey = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 'x', '*', '/', '.', '+', '-', '%', '^', '(', ')'];
                $.extend(opt, _opt);
                this.init.call(this);
            } else {
                this[opt].apply(this, Array.prototype.slice.call(_args, 1));
            }
        });
    };

    $.fn.formula.getVersion = function () {
        return _PLUGIN_VERSION_;
    };
}(jQuery));
var FormulaParser = (function () {
    var _PLUGIN_VERSION_ = '2.0.11';

    function FormulaParser(formula) {
        var idx;
        this.formula = formula;

        /***********************************************
         *
         * @ Note OperandToken Declaration
         *
         **********************************************/

        this.OperandToken = {};
        this.OperandToken.Addition = ['+'];
        this.OperandToken.Subtraction = ['-'];
        this.OperandToken.Multiplication = ['x', '*'];
        this.OperandToken.Division = ['/'];
        this.OperandToken.Mod = ['%'];
        this.OperandToken.Pow = ['^'];
        this.OperandToken.Bracket = ['(', ')', '[', ']', '{', '}'];

        /***********************************************
         *
         * @ Note Resitration the priority.
         *
         **********************************************/

        this.OperandPriority = [];
        this.OperandPriority[0] = [].concat(this.OperandToken.Mod, this.OperandToken.Pow);
        this.OperandPriority[1] = [].concat(this.OperandToken.Multiplication, this.OperandToken.Division);
        this.OperandPriority[2] = [].concat(this.OperandToken.Addition, this.OperandToken.Subtraction);

        /***********************************************
         *
         * @ Note Resitration operators.
         *
         **********************************************/

        this.Operators = [];
        for (idx in this.OperandToken) {
            var item = this.OperandToken[idx];
            this.Operators = this.Operators.concat(item);
        }

        /***********************************************
         *
         * @ Note Resitration units.
         *
         **********************************************/

        this.Units = [].concat(this.Operators, this.OperandToken.Bracket);

        /***********************************************
         *
         * @ Note Resitration parsers.
         *
         **********************************************/

        this.Parsers = [
            'Initializer',
            'LayerParser',
            'SyntaxParser',
            'FilterParser',
            'StringParser'
        ];

        this.ParserMap = {};

        for (idx in this.Parsers) {
            var parser = this.Parsers[idx];
            this.ParserMap[parser] = parser;
        }

        this.Message = {};
        this.Message[0x01] = 'Formula must has characters than {0} times';
        this.Message[0x02] = '\'{0}\' operator is not supported.';
        this.Message[0x03] = 'Left side operand is not valid.';
        this.Message[0x04] = 'Right side operand is not valid.';
        this.Message[0x05] = 'Bracket must be opened.';
        this.Message[0x06] = 'Bracket must be closed.';
        this.Message[0x20] = 'Operator\'s key must be in data.';
        this.Message[0x21] = 'Left operand\'s key must be in data.';
        this.Message[0x22] = 'Right operand\'s key must be in data.';
        this.Message[0xA0] = 'Formula expression is null or undefined.';

        /***********************************************
         *
         * @ Start to parsing.
         *
         **********************************************/

        return this.init();
    }

    /**
     * This method retuns current version. (This isn't prototype function.)
     * @namespace FormulaParser
     * @method getVersion
     * @returns {Number}
     */
    FormulaParser.getVersion = function () {
        return _PLUGIN_VERSION_;
    };

    /**
     * When item is in the array, This will returns true.
     * @namespace FormulaParser
     * @method inArray
     * @param {Any} item condition parameter
     * @param {Array} array base target parameter
     * @returns {bool}
     */
    FormulaParser.prototype.inArray = function (item, array) {
        for (var idx in array) if (array[idx] === item) return idx;
        return -1;
    };

    /**
     * When item is operand type(number, object), This will returns true.
     * @namespace FormulaParser
     * @method isOperand
     * @param {Dynamic} item
     * @returns {bool} When parameter is operand type, This function will returuns true.
     */
    FormulaParser.prototype.isOperand = function (item) {
        return typeof item === 'object' || this.isNumeric(item);
    };

    /**
     * Get operator string to priority number.
     * @namespace FormulaParser
     * @method getOperatorPriority
     * @param {String} operator
     * @returns {Number}
     */
    FormulaParser.prototype.getOperatorPriority = function (operator) {
        if (this.inArray(operator, this.Operators) === -1) {
            return -1;
        } else {
            var priority = -1;
            for (var idx = 0; idx < this.OperandPriority.length; idx++) {
                if (this.inArray(operator, this.OperandPriority[idx]) !== -1) {
                    priority = idx;
                    break;
                }
            }
            return priority;
        }
    };

    /**
     * When item is number type, This will returns true. The method is part of isOperand.
     * @namespace FormulaParser
     * @method isNumeric
     * @param {Number} n - number
     * @returns {bool} When parameter is numeric this function returns true
     */
    FormulaParser.prototype.isNumeric = function (n) {
        return (/\d+(\.\d*)?|\.\d+/).test(n);
    };

    /**
     * This method can make string type formula to array.
     * @namespace FormulaParser
     * @method stringToArray
     * @param {String} s - formula string
     * @returns {array}
     */
    FormulaParser.prototype.stringToArray = function (s) {
        var data = [];
        var dataSplited = s.split('');
        var dataSplitedLen = dataSplited.length;
        for (var idx = 0; idx < dataSplitedLen; idx++) {
            var item = dataSplited[idx];
            if (this.inArray(item, this.Units) !== -1 || this.isOperand(item) === true) {
                if (idx > 0 && this.isOperand(item) === true && this.isOperand(data[data.length - 1]) === true) {
                    data[data.length - 1] += item.toString();
                } else {
                    data.push(item);
                }
            }
        }
        return data;
    };

    /**
     * Standard logger for formula parser, But this method does not display in console.
     * @namespace FormulaParser
     * @method log
     * @param {Number} code - return code
     * @param {Dynamic} data - return data
     * @param {Array} mapping - return message mapping data
     * @returns {array}
     */
    FormulaParser.prototype.log = function (code, data, mapping) {
        var message = this.Message[code], idx, item;

        for (idx in mapping) {
            item = mapping[idx];
            message = message.replace(new RegExp('\\\{' + idx + '\\\}', 'g'), item);
        }

        var obj = {
            status: code === 0x00,
            code: code,
            msg: message
        };

        if (typeof data !== 'undefined' && data !== null) {
            for (idx in data) {
                item = data[idx];
                if (typeof item !== 'function') {
                    obj[idx] = item;
                }
            }
        }

        return obj;
    };

    /**
     * Layer parser is examination all formula syntax minutely and parsing by search method.
     * @namespace FormulaParser
     * @method layerParser
     * @related search method
     * @param {Array} data - formula array data
     * @param {Number} pos - formula stack cursor
     * @param {Number} depth - formula search depth (start from 0)
     * @returns {Object}
     */
    FormulaParser.prototype.layerParser = function (data, pos, depth) {
        var innerDepth = 0;
        var startPos = [], endPos = [];
        var currentParser = this.ParserMap.LayerParser;
        var totalLength = data.length;

        depth = depth || 0;

        if (typeof data === 'object' && data.length === 1) {
            return {
                status: true,
                data: data[0],
                length: 1
            };
        }

        for (var idx = 0; idx < data.length; idx++) {
            var item = data[idx];
            if (item === '(') {
                innerDepth++;
                startPos[innerDepth] = idx + 1;
            } else if (item === ')') {
                if (innerDepth < 1) {
                    return this.log(0x05, {
                        stack: currentParser,
                        col: startPos.length > 0 ? startPos[startPos.length - 1] : 0
                    });
                }

                if (innerDepth === 1) {
                    var paramData = [];
                    endPos[innerDepth] = idx - 1;

                    for (var j = startPos[innerDepth]; j <= endPos[innerDepth]; j++) {
                        paramData.push(data[j]);
                    }

                    var result = this.search(paramData, pos + startPos[innerDepth] + 1, depth + 1);

                    if (result.status === false) {
                        return result;
                    } else {
                        var length = result.length;
                        if (typeof result.data === 'object' && typeof result.data[0] !== 'object' && result.data.length === 1) {
                            result.data = result.data[0];
                        }
                        data.splice(startPos[innerDepth] - 1, length + 2, result.data);
                        idx -= length + 1;
                    }
                }
                innerDepth--;
            }
        }

        if (innerDepth > 0) {
            return this.log(0x06, {
                stack: currentParser,
                col: data.length || -1
            });
        }

        return {
            status: true,
            depth: depth,
            length: totalLength || -1
        };
    };

    /**
     * Syntax layer makes formula object from formula expression.
     * @namespace FormulaParser
     * @method syntaxParser
     * @related search method
     * @param {Array} data - formula array data
     * @param {Number} pos - formula stack cursor
     * @param {Number} depth - formula search depth (start from 0)
     * @param {Number} length - compressed formula expression length
     * @param {Array} operators - permitted formula unit array
     * @returns {Object}
     */
    FormulaParser.prototype.syntaxParser = function (data, pos, depth, length, operators) {
        this.currentParser = this.ParserMap.SyntaxParser;

        data = data || [];
        pos = pos || 0;
        depth = depth || 0;

        var cursor = pos;

        if (
            typeof data[0] !== 'undefined' &&
            data[0] !== null &&
            typeof data[0][0] === 'object' &&
            (
                typeof data[0].operator === 'undefined' ||
                data[0].operator === null
            )
        ) {
            data[0] = data[0][0];
        }

        if (data.length < 3) {
            if (typeof data === 'object' && data.length === 1) {
                return data[0];
            } else {
                return this.log(0x01, {
                    stack: this.currentParser,
                    col: pos + (typeof data[0] === 'object' ? data[0].length : 0) + 1
                }, [3]);
            }
        }

        if (typeof data.length !== 'undefined') {
            if (data.length > 1) {
                for (var idx = 0; idx < data.length; idx++) {
                    cursor = idx + pos;
                    var item = data[idx];
                    if (this.inArray(item, this.Operators) === -1 && this.isOperand(item) === false) {
                        return this.log(0x02, {
                            stack: this.currentParser,
                            col: cursor
                        }, [item]);
                    }

                    if (this.inArray(item, operators) !== -1) {
                        if (this.isOperand(data[idx - 1]) === false) {
                            return this.log(0x03, {
                                stack: this.currentParser,
                                col: cursor - 1
                            });
                        }

                        if (this.isOperand(data[idx + 1]) === false) {
                            return this.log(0x04, {
                                stack: this.currentParser,
                                col: cursor + 1
                            });
                        }

                        if (typeof data[idx - 1] === 'object' && data[idx - 1].length === 1) {
                            data[idx - 1] = data[idx - 1][0];
                        }

                        if (typeof data[idx + 1] === 'object' && data[idx + 1].length === 1) {
                            data[idx + 1] = data[idx + 1][0];
                        }

                        data.splice(idx - 1, 3, {
                            operator: item,
                            operand1: data[idx - 1],
                            operand2: data[idx + 1],
                            length: length
                        });

                        if (typeof data[idx - 1][0] === 'object') {
                            data[idx - 1] = data[idx - 1][0];
                        }

                        idx--;
                    }
                }
            }
        }

        return {
            status: true,
            data: data
        };
    };

    /**
     * Filter parser remains the formula object's only useful data for user
     * @namespace FormulaParser
     * @method filterParser
     * @related search method
     * @param {Object} data - formula object
     * @returns {Object}
     */
    FormulaParser.prototype.filterParser = function (data) {
        if (typeof data.operand1 === 'object') {
            this.filterParser(data.operand1);
        }

        if (typeof data.operand2 === 'object') {
            this.filterParser(data.operand2);
        }

        if (typeof data.length !== 'undefined') {
            delete data.length;
        }

        if (typeof data === 'object' && data.length === 1) {
            data = data[0];
        }

        return data;
    };

    /**
     * String parser is using for convert formula object to readable formula array.
     * @namespace FormulaParser
     * @method stringParser
     * @related collapse method
     * @param {Object} data - formula object
     * @param {Number} depth - formula parse depth
     * @param {Number} pos - formula stack cursor
     * @returns {Array}
     */
    FormulaParser.prototype.stringParser = function (data, depth, pos) {
        this.currentParser = this.ParserMap.StringParser;

        var _this = this;
        var formula = [];

        depth = depth || 0;
        pos = pos || 0;

        if (typeof data.value === 'undefined' || data.value === null) {
            if (typeof data.operator === 'undefined' || data.operator === null) {
                return this.log(0x20, {
                    stack: this.currentParser,
                    col: pos,
                    depth: depth
                });
            } else if (typeof data.operand1 === 'undefined' || data.operand1 === null) {
                return this.log(0x21, {
                    stack: this.currentParser,
                    col: pos,
                    depth: depth
                });
            } else if (typeof data.operand2 === 'undefined' || data.operand2 === null) {
                return this.log(0x22, {
                    stack: this.currentParser,
                    col: pos,
                    depth: depth
                });
            }
        } else {
            return {
                status: true,
                data: ((data.value.type === 'unit') ? data.value.unit : data.value)
            };
        }

        var params = ['operand1', 'operator', 'operand2'];
        for (var idx = 0; idx < params.length; idx++) {
            var param = params[idx];
            if (typeof data[param] === 'object') {
                var result = _this.stringParser(data[param], depth + 1, pos + idx);
                if (result.status === false) {
                    return result;
                } else {
                    formula = formula.concat(result.data);
                    if (typeof data.operator !== 'undefined' && data.operator !== null && typeof result.operator !== 'undefined' && result.operator !== null) {
                        if (this.getOperatorPriority(data.operator) < this.getOperatorPriority(result.operator) && this.getOperatorPriority(data.operator) !== -1) {
                            formula.splice([formula.length - 3], 0, '(');
                            formula.splice([formula.length], 0, ')');
                        }
                    }
                }
            } else {
                formula.push(data[param]);
            }
        }

        return {
            status: true,
            data: formula,
            operator: depth > 0 ? data.operator : undefined
        };
    };

    /**
     * Search method routes each of commands to right steps.
     * @namespace FormulaParser
     * @method search
     * @related layerParser, syntaxParser, filterParser methods.
     * @param {Array} data - formula array data
     * @param {Number} pos - formula stack cursor
     * @param {Number} depth - formula search depth (start from 0)
     * @returns {Object}
     */
    FormulaParser.prototype.search = function (data, pos, depth) {
        var _super = this;
        pos = pos || 0;
        depth = depth || 0;

        if (typeof data === 'string' && depth < 1) {
            data = this.stringToArray(data);
        }

        var result = null;
        var len = this.OperandPriority.length + 1;
        var parserLength = 0;
        var parserComplete = function () {
            if (depth === 0) {
                data = _super.filterParser(data);
            }

            return {
                status: true,
                data: data,
                length: depth === 0 ? undefined : parserLength,
                depth: depth === 0 ? undefined : depth
            };
        };

        for (var i = 0; i < len; i++) {
            if (result !== null && typeof result.data !== 'undefined' && result.data.length === 1) {
                return parserComplete.call();
            }

            if (i === 0) {
                result = this.layerParser(data, pos, depth);
                parserLength = result.length;
            } else {
                result = this.syntaxParser(data, pos, depth, parserLength, this.OperandPriority[i - 1]);
            }

            if (result.status === false) {
                return result;
            } else if (i + 1 === len) {
                return parserComplete.call();
            }
        }
    };

    /**
     * Collapse method can convert formula object to readable and user-friendly formula array.
     * @namespace FormulaParser
     * @method collapse
     * @related stringParser method.
     * @param {Object} data - formula object data
     * @param {Number} depth - formula search depth (start from 0)
     * @returns {Object}
     */
    FormulaParser.prototype.collapse = function (data, depth) {
        var _this = this, formula = null;
        depth = depth || 0;
        formula = this.stringParser(data, depth);

        return {
            status: true,
            data: formula.data
        };
    };

    /**
     * Init method is fired when you declare FormulaParser object by new keyword.
     * @namespace FormulaParser
     * @method init
     * @related FormulaParser object.
     * @returns {Dynamic}
     */
    FormulaParser.prototype.init = function () {
        if (typeof this.formula === 'undefined' || this.formula === null) {
            return this.log(0xA0, {
                stack: this.Parsers.Initializer,
                col: 0
            });
        } else if (typeof this.formula === 'string' || (typeof this.formula === 'object' && (typeof this.formula.operator === 'undefined' || this.formula.operator === null))) {
            return this.search(this.formula);
        } else if (typeof this.formula === 'object' && typeof this.formula.operator !== 'undefined' && this.formula.operator !== null) {
            return this.collapse(this.formula);
        } else {
            console.error('Unkown type formula', this.formula);
        }
    };

    return FormulaParser;
})();
