## Application level

Link to [foo chapter](#foo-chapter)
Link to [foo chapter](#foobar)
### Relative Anchors
**Embedded Anchors**
Example Privacy Policy with relative anchor inside Text (e.g. to Section "Foobar").
Section "Foobar" is located later inside the text so its not visible from the start.

1. Assert Section "Foobar" is not visible
2. Click on anchor
3. Assert Section header "Foobar" and start of Foobar section text is visible
(Can we assert its at the top of the screen?)

**Anchors from TOC Sidebar**
Example Privacy Policy.
TOC on the side with sections of privacy policy (e.g. "Foobar").
Section "Foobar" is located later inside the text so its not visible from the start.

1. Assert Section "Foobar" is not visible
2. Click on Heading inside TOC
3. Assert Section header "Foobar" and start of Foobar section text is visible
(Can we assert its at the top of the screen?)

**Edge Case: Last chapters (can't scroll them up to the start of the page)**
Since the last chapter is at the bottom of the page we can never scroll it up to the top of the page.
We can only scroll to the end of the page. The heading of the last chapter will still be at the bottom of the page 
(if the text below is not long enough to be able to scroll until the heading is at the top.)

Should we test for that?
How?

### Currently reading TOC section highlight
**Simple case**
Example Privacy Policy.
TOC on the side with sections of privacy policy (e.g. "Foobar").
Section "Foobar" is located later inside the text so its not visible from the start.

1. Assert Foobar section not highlighted
2. Scroll down to Foobar section header
3. Assert Foobar section is highlighted
4. Scroll down to Foobar text end (text is still visible)
5. Assert Foobar section is highlighted

(Maybe split into two tests?)
(Or should we just click on the header to automatically scroll to relativ anchor?)

**First section**
What should we highlight if there is text at the start without a section?
Nothing? Default Section ("Einführung")? 

**Edge case: chapters at the end**
Since chapter headings at the very end can't scroll up all the way we can't only say that the chapter at the very top is the one we're currently reading.

Image that the privacy policy ends like this and the user can't scroll further:
```markdown
<!-- Continuation of foo chapter-->
foo foo foo foofoo foofoo foofoo foofoo foo
foo foofoo foo
foo foofoo foofoo foofoo foo
foo foofoo foofoo foo
## Foobar chapter
foobarfoobar foobar foobar foobarfoobar foobarfoobar foobar foobar foobarfoobar
foobarfoobar foobar foobar foobarfoobar
foobarfoobar foobar foobar foobarfoobarfoobarfoobar foobar foobar foobarfoobar
## Last chapter
last  last last last last last last last last last 
last last 

last last last last last 
```

Since at the upper end of the page we have the "foo" chapter but we can't scroll further we might guess that the user is currently reading the "foo" section.  

How do we handle this case?

**Special logic**
We might add special logic that if the user scrolls to the end of the privacy policy then automatically the last chapter is highlighted.
This would mean though that we might still skip the second last chapter in the example above.

Or we could highlight all chapters that are visible (like below) when the user scrolled to the bottom of the page. 
Then it might not be as confusing for the user in the normal case with the cost that it might be suprising to have multiple
chapters highlighted only if scrolled to the very end. 

**Multi chapter highlighting**
We might always highlight all chapters that are currently visible.
That means if a user is between to chapter (parts of both visible) then both will be highlighted.
Might confuse some users why multiple chapters are highlighted (or maybe not).

--> I think special logic that at the bottom we just highlight the last chapter is the best solution.
Maybe with some padding so we don't highlight the last section only when scrolled completly to the last pixel but also a bit before. 

## flutter_markdown level

### Relative anchor scrolling
AnchorScrollController
.scrollToAnchor(String anchorId)

Should we add parameters from ItemScrollController.scrollTo?
```
  Future<void> scrollTo({
    required int index,
    double alignment = 0,
    required Duration duration,
    Curve curve = Curves.linear,
    List<double> opacityAnimationWeights = const [40, 20, 40],
  }) {
```

**AnchorId not found**  
Either:
* Doesn't do anything if anchorId is not found
* Throws an exception of anchorId is not found

**Single anchorId**  
Scrolls to anchor if found (single anchor with name)  
--> Test alignment?

**Multiple anchorIds**  
Scrolls to first anchor if multiple are found
(See: [CommonMark Spec][common-mark-multiple-links] )
"If there are multiple matching reference link definitions, the one that comes first in the document is used. (It is desirable in such cases to emit a warning.)" --> NVM is something different I think)   
--> Can this even happen?  



[common-mark-multiple-links]: https://spec.commonmark.org/0.30/#:~:text=If%20there%20are%20multiple%20matching%20reference%20link%20definitions%2C%20the%20one%20that%20comes%20first%20in%20the%20document%20is%20used.%20(It%20is%20desirable%20in%20such%20cases%20to%20emit%20a%20warning.)

### Header Positions
```dart
class HeaderPosition {
  final String headerAnchorId;
  final double itemLeadingEdge;
  final double itemTrailingEdge;
}
```
Idk if it makes sense to only expose the position of a Header, it can probably be also useful in other cases.   

Might be confusing bc Api is not symmetrical (`AnchorScrollController` but no `AnchorPosition`). `AnchorPosition` would probably make more sense but idk how I would implement this.

`AnchorRepository` und `Anchor(id, index)`.

**Header position if header is on top of page should be 0** 
--> Use AnchorScrollController.scrollTo(anchor?)
(Or not so they don't depend on each other?)

**Header position if header is at bottom of page should be 1** 

*Or instead*

# Foo chapter

wadawd

wd

<a id="foobar"></a> abcdef


----
Nach h1-h6 Elementen suchen oder SetextHeader
falls id diese und den Header Text speichern.
Nachher in Widget nach dem Header Text suchen (was ist falls der noch zusätzliche Formatierung hat?)

for (...) {
    final widget = widgets[i];
    if(widget is AnchorWrapper) {
        _anchors[widget.anchorId] = i;
    }
}

int indexForAnchor(String anchorId) {
    return _anchors[anchorId];
}

1. Jede href speichern
2. Von allen h1-h6 den textContent speichern und zu Ids konvertieren
3. Falls Id von Schritt zwei mit einer href übereinstimmt, dann den AnchorWrapper(anchorId: href) drummachen
--> Kann noch gar nicht wissen, ob die übereinstimmen, weil nachher erst ein href kommen kann


TODO Auf GitHub hinweisen, dass es verwirrend ist, dass der Dart Markdown Live Editor
 https://dart-lang.github.io/markdown/ nicht auf Flutter sondern HTML basiert (weil der bei flutter_markdown verlinkt wird). Da werden dann zB HTML Tags im Text nicht angezeigt, aber in Flutter schon.


 https://github.com/flutter/packages/compare/main...SharezoneApp:main


(Copied, from Desktop maybe old:)

 ## Application level

### Relative Anchors
**Embedded Anchors**
Example Privacy Policy with relative anchor inside Text (e.g. to Section "Foobar").
Section "Foobar" is located later inside the text so its not visible from the start.

1. Assert Section "Foobar" is not visible
2. Click on anchor
3. Assert Section header "Foobar" and start of Foobar section text is visible
(Can we assert its at the top of the screen?)

**Anchors from TOC Sidebar**
Example Privacy Policy.
TOC on the side with sections of privacy policy (e.g. "Foobar").
Section "Foobar" is located later inside the text so its not visible from the start.

1. Assert Section "Foobar" is not visible
2. Click on Heading inside TOC
3. Assert Section header "Foobar" and start of Foobar section text is visible
(Can we assert its at the top of the screen?)

### Currently reading TOC section highlight
**Simple case**
Example Privacy Policy.
TOC on the side with sections of privacy policy (e.g. "Foobar").
Section "Foobar" is located later inside the text so its not visible from the start.

1. Assert Foobar section not highlighted
2. Scroll down to Foobar section header
3. Assert Foobar section is highlighted
4. Scroll down to Foobar text end (text is still visible)
5. Assert Foobar section is highlighted

(Maybe split into two tests?)
(Or should we just click on the header to automatically scroll to relativ anchor?)

**First section**
What should we highlight if there is text at the start without a section?
Nothing? Default Section ("Einführung")? 

## flutter_markdown level

### Relative anchor scrolling
RelativeAnchorScrollController
.scrollToHeader(String headerId

### Header Positions
HeaderPositionsListener
.double itemLeadingEdge
.double itemTrailingEdge
.String headerId
