// protoHover
// a simple hover implementation for prototype.js
// Sasha Sklar and David Still

(function() {
	// copied from jquery
	var withinElement = function(evt, el) {
		// Check if mouse(over|out) are still within the same parent element
		var parent = evt.relatedTarget;

		// Traverse up the tree
		while (parent && parent != el) {
			try {
				parent = parent.parentNode;
			} catch (error) {
				parent = el;
			}
		}
		// Return true if we actually just moused on to a sub-element
		return parent == el;
	};

	// Extend event with mouseEnter and mouseLeave
	Object.extend(Event, {
		mouseEnter: function(element, f, options) {
			element = $(element);

			// curry the delay into f
			var fc = (options && options.enterDelay)?(function(){window.setTimeout(f, options.enterDelay);}):(f);

			if (Prototype.Browser.IE) {
				element.observe('mouseenter', fc);
			} else {
				element.hovered = false;

				element.observe('mouseover', function(evt) {
					// conditions to fire the mouseover
					// mouseover is simple, the only change to default behavior is we don't want hover fireing multiple times on one element
					if (!element.hovered) {
						// set hovered to true
						element.hovered = true;

						// fire the mouseover function
						fc(evt);
					}
				});
			}
		},
		mouseLeave: function(element, f, options) {
			element = $(element);

			// curry the delay into f
			var fc = (options && options.leaveDelay)?(function(){window.setTimeout(f, options.leaveDelay);}):(f);

			if (Prototype.Browser.IE) {
				element.observe('mouseleave', fc);
			} else {
				element.observe('mouseout', function(evt) {
					// get the element that fired the event
					// use the old syntax to maintain compatibility w/ prototype 1.5x
					var target = Event.element(evt);

					// conditions to fire the mouseout
					// if we leave the element we're observing
					if (!withinElement(evt, element)) {
						// fire the mouseover function
						fc(evt);

						// set hovered to false
						element.hovered = false;
					}
				});
			}
		}
	});


	// add method to Prototype extended element
	Element.addMethods({
		'hover': function(element, mouseEnterFunc, mouseLeaveFunc, options) {
			options = Object.extend({}, options) || {};
			Event.mouseEnter(element, mouseEnterFunc, options);
			Event.mouseLeave(element, mouseLeaveFunc, options);
		}
	});
})();