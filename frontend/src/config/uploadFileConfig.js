import { Cloudinary } from "@cloudinary/url-gen";


const cloudName = "dk5bp3p9l";
console.log("🚀 ~ cloudName:", cloudName)
const uploadPreset = "yrbkawdp";
console.log("🚀 ~ uploadPreset:", uploadPreset)


const cld = new Cloudinary({
  cloud: {
    cloudName: cloudName, // Replace with your Cloudinary cloud name
  },
});

// Example: Generating an image URL
const imageUrl = cld.image("example-public-id").toURL();
console.log("Generated Image URL:", imageUrl);

export const uploadToCloudinary = async (file) => {
  console.log("🚀 ~ uploadToCloudinary ~ file:", file)

  
  const formData = new FormData();
  formData.append("file", file);
  formData.append("upload_preset", "yrbkawdp"); // Replace with your upload preset

  for (let [key, value] of formData.entries()) {
    console.log(`${key}:`, value);
  }

  try {
    const response = await fetch(
      `https://api.cloudinary.com/v1_1/dk5bp3p9l/upload`,
      {
        method: "POST",
        body: formData,
      }
    );

    const data = await response.json();
    console.log("Uploaded file:", data);

    return data;
  } catch (error) {
    console.error("Error uploading to Cloudinary:", error);
  }
};
