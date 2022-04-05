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
