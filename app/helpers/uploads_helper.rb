module UploadsHelper

  def file_uploader
    out = ""
    out << "\n"
    out << link_to('Upload File(s)', '#',:id=> 'upload_link')
    out << "\n"
    out << content_tag(:ul, '', :id => 'uploader_file_list')
    out << "\n"

    out << javascript_tag("window.addEvent('domready', function() {

    /**
     * Uploader instance
     */
    var up = new FancyUpload3.Attach('uploader_file_list', '#upload_link', {
      path: 'http://#{request.host_with_port}/javascripts/fancyupload/source/Swiff.Uploader.swf',
      url: 'http://#{request.host_with_port}/uploads/upload',
      fieldName: 'file',
      fileSizeMax: 2000 * 1024 * 1024,

      //verbose: true,

      onSelectFail: function(files) {
        files.each(function(file) {
          new Element('li', {
            'class': 'file-invalid',
            events: {
              click: function() {
                this.destroy();
              }
            }
          }).adopt(
            new Element('span', {html: file.validationErrorMessage || file.validationError})
          ).inject(this.list, 'bottom');
        }, this);
      },

      onFileComplete: function(file) {
        if (file.response.code == 201 || file.response.code == 0){
          file.ui.element.highlight('#e6efc2');
          file.ui.element.children[2].setStyle('display','none');
          file.ui.element.children[3].setStyle('display','none');
        }
      },

      onFileError: function(file) {
        if (file.response.code != 201){
          file.ui.cancel.set('html', 'Retry').removeEvents().addEvent('click', function() {
            file.requeue();
            return false;
          });

          new Element('span', {
            html: file.errorMessage,
            'class': 'file-error'
          }).inject(file.ui.cancel, 'after'); }
      },

      onFileRequeue: function(file) {
        file.ui.element.getElement('.file-error').destroy();

        file.ui.cancel.set('html', 'Cancel').removeEvents().addEvent('click', function() {
          file.remove();
          return false;
        });

        this.start();
      }

      });

    });")

  end


end
