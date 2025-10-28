//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class AboutYourServiceVC: UIViewController {
    
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var idDoc: UIImageView!
    @IBOutlet weak var certificateBG: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueTo(_ sender: InterButton) {
        Task { await completeOnboarding() }
    }
    
    @IBAction func profilePic(_ sender: UIButton) {
        MediaPicker.shared.browsedImage() { [weak self] image, _ in
            self?.userProfilePic.image = image
        }
    }
    
    @IBAction func uploadIDDoc(_ sender: UIButton) {
        MediaPicker.shared.browsedImage() { [weak self] image, _ in
            self?.idDoc.image = image
        }
    }
    
    @IBAction func uploadCertificateBG(_ sender: UIButton) {
        MediaPicker.shared.browsedImage() { [weak self] image, _ in
            self?.certificateBG.image = image
        }
    }
}

extension AboutYourServiceVC {
    fileprivate func completeOnboarding() async {
        var medias = [Media]()
        if userProfilePic.image != nil, let data = userProfilePic.image?.jpegData(compressionQuality: 1.0) {
            let ms = Int(Date().timeIntervalSince1970 * 1000) // milliseconds precision
            let filename = "\(ms).profile_pic.jpg"
            let media = Media(filename: filename,
                              data: data,
                              keyname: .profileImage,
                              contentType: .imageJPEG)
            medias.append(media)
        }
        
        if idDoc.image != nil, let data = idDoc.image?.jpegData(compressionQuality: 1.0) {
            let ms = Int(Date().timeIntervalSince1970 * 1000) // milliseconds precision
            let filename = "\(ms).document.jpg"
            let media = Media(filename: filename,
                              data: data,
                              keyname: .document,
                              contentType: .imageJPEG)
            medias.append(media)
        }
        
        if certificateBG.image != nil, let data = certificateBG.image?.jpegData(compressionQuality: 1.0) {
            let ms = Int(Date().timeIntervalSince1970 * 1000) // milliseconds precision
            let filename = "\(ms).backgroundCheckCertificate.jpg"
            let media = Media(filename: filename,
                              data: data,
                              keyname: .backgroundCheckCertificate,
                              contentType: .imageJPEG)
            medias.append(media)
        }
        
        let res = await RemoteRequestManager.shared.uploadTask(endpoint: .completeOnboarding,
                                                               model: UserDetails.self,
                                                               method: .put,
                                                               medias: medias)
        await MainActor.run {
            switch res {
            case .failure(let err):
                Toast.show(message: err.localizedDescription)
                
            case .success:
                SharedMethods.shared.pushToWithoutData(destVC: LocationPermissionVC.self, isAnimated: true)
            }
        }
    }
}
