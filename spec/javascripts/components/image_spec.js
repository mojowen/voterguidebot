describe('ImageComponent', function() {
  var transparentGif = "data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==",
      fakeFile = {name: "test name",size: 2 * 1024 * 1024,
          width: 200,
          height: 100}

  beforeEach(function() {
    this.setUpComponent(ImageComponent, {})
    this.dropzone = this.component.dropzone
  })

  it('it renders successfully', function() {
    expect(this.dom.className.search('.dz-clickable')).not.toEqual(-1)
  })

  it('handles thumbnail by processing data', function() {
    this.dropzone._callbacks.thumbnail[1].call(this.dropzone, fakeFile, transparentGif)
    expect(this.component.state.value).toEqual(transparentGif)
  })

  describe('with an existing image', function() {
    beforeEach(function() {
      this.props = {
        value: transparentGif,
        preview: true,
        onChange: function() { }
      }

      spyOn(this.props, 'onChange')
      this.setUpComponent(ImageComponent, this.props)
      this.dropzone = this.component.dropzone
    })

    it('loads image', function() {
      expect(this.component.state.value).toEqual(transparentGif)
      expect(this.dom.querySelector('img').src).toEqual(transparentGif)
    })

    it('can clear the current image', function() {
      this.component.handleClear({ preventDefault: function() {} })
      expect(this.component.state.value).toEqual(null)
      expect(this.props.onChange).toHaveBeenCalledWith({ target: { value: null, name: ''}})
    })
  })

  describe('with a callback', function() {
    beforeEach(function() {
      this.callback = function() {}
      spyOn(this, 'callback')
      this.setUpComponent(ImageComponent, { onChange: this.callback })
      this.dropzone = this.component.dropzone
    })

    it('does not propagate values with thumbnail', function() {
      this.dropzone._callbacks.thumbnail[1].call(this.dropzone, fakeFile, transparentGif)
      expect(this.callback).not.toHaveBeenCalled()
    })

    it('does propagate values with thumbnail', function() {
      var fake_response = { xhr: { response: '{"path":"some-remote"}' }}
      this.dropzone._callbacks.success[1].call(this.dropzone, )
      expect(this.callback).toHaveBeenCalledWith("some-remote")
    })
  })

  describe('with a guide resource', function() {
    beforeEach(function() {
      this.setUpComponent(ImageComponent, {})
      // Set up the component twice to allow mocking
      this.component.dropzone.element.dropzone = null
      spyOn(this.component, 'pathname').and.returnValue('/guides/5/fields')
      this.component.componentDidMount()
      this.dropzone = this.component.dropzone
    })

    it('propagates values with an onChange', function() {
      expect(this.dropzone.options.url).toEqual('/uploads?guide_id=5')
    })
  })
})
