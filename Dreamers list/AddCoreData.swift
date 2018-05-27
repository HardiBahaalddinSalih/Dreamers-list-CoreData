import UIKit
import CoreData

class AddCoreData: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var captionTxt: UITextView!
    @IBOutlet weak var bodyTxt: UITextView!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var dreams : [Dreamer] = []
    var selectedImage: UIImage?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBtn.layer.cornerRadius = 5
        mainImage.layer.cornerRadius = 14
        
        
    }
    
    @IBAction func saveBtn_Tapped(_ sender: Any) {
        save { (success) in
            //Retern to Previous location
            navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    
    
    //connect selected image to our ImageView
    @IBAction func addPicBtnWasPressed(_ sender: AnyObject) {
        view.endEditing(true)
        
        let picker = UIImagePickerController()
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.navigationBar.barTintColor = #colorLiteral(red: 0.7756819751, green: 0.4081383805, blue: 0.6004659487, alpha: 1)
        picker.navigationBar.tintColor = UIColor.white
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[ UIImagePickerControllerOriginalImage ] as? UIImage
        selectedImage = image
        mainImage.image = image
        mainImage.backgroundColor = UIColor.clear
        mainImage.contentMode = UIViewContentMode.scaleToFill
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AddCoreData {
    func save(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let dreamer = Dreamer(context: managedContext)
        guard let name = nameTxt.text else {return }
        if let profileImg = self.selectedImage ,
            let imageData = UIImageJPEGRepresentation(profileImg, 0.5) {
            dreamer.image = imageData
            dreamer.name = name
            dreamer.caption = captionTxt.text
            dreamer.body = bodyTxt.text
            let date = Date()
            dreamer.date = date
        
            
        } else {
            debugPrint("youneed to have picture")
        }
        
        do {
            try managedContext.save()
            print("Successfully saved data.")
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
}
