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
    this.component.setState({ is_saving: true })
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
      swalSpy.confirmLast(true)
      expect(this.dom.querySelector('div.img').style.backgroundImage).toMatch(transparentGif)
    })

    it('can clear the current image', function() {
      this.component.handleClear({ preventDefault: function() {} })
      swalSpy.confirmLast(true)
      expect(this.component.state.value).toEqual(null)
      expect(this.props.onChange).toHaveBeenCalledWith({ target: { value: null, name: ''}})
    })
  })

  describe('with a callback', function() {
    beforeEach(function() {
      this.onChange = function() {}
      spyOn(this, 'onChange')
      this.onStart = function() {}
      spyOn(this, 'onStart')
      this.setUpComponent(ImageComponent, { onChange: this.onChange,
                                            onStart: this.onStart })
      this.dropzone = this.component.dropzone
    })

    it('does not propagate values with thumbnail', function() {
      this.dropzone._callbacks.thumbnail[1].call(this.dropzone, fakeFile, transparentGif)
      expect(this.onChange).not.toHaveBeenCalled()
    })

    it('does propagate values with thumbnail', function() {
      var fake_response = { xhr: { response: '{"path":"some-remote"}' }}
      this.dropzone._callbacks.success[1].call(this.dropzone, fake_response)
      expect(this.onChange).toHaveBeenCalledWith({ target: { value: "some-remote", name: '' } })
    })

    it('calls onStart when the process begins', function() {
      this.dropzone._callbacks.addedfile[1].call(this.dropzone)
      expect(this.onStart).toHaveBeenCalled()
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

  describe('with a failed response', function() {
    beforeEach(function() {
      this.setUpComponent(ImageComponent, {})
      this.dropzone = this.component.dropzone
      this.component.setState({ value: 'yaba-daba-do' })

      this.error_message = "some-error"
      this.fake_response = { xhr: { response: JSON.stringify({ error: this.error_message }) }}
    })

    it('reverts value to null if not set', function() {
      this.dropzone._callbacks.error[1].call(this.dropzone, this.fake_response)
      expect(this.component.state.value).toEqual(null)
    })
    it('reverts to previousValue if set', function() {
      var old_value = 'meet-the-flintstones'
      this.component.setState({ previousValue: old_value })
      this.dropzone._callbacks.error[1].call(this.dropzone, this.fake_response)
      expect(this.component.state.value).toEqual(old_value)
    })
    it('notifies the user', function() {
      this.dropzone._callbacks.error[1].call(this.dropzone, this.fake_response)
      expect(swalSpy).toHaveBeenCalledWith({ title: 'Uh Oh!', text: this.error_message })
    })
  })
})
