/**
 * Client-side image processing: resize and convert to WebP before upload.
 * Import this in admin pages with <script> tags.
 */

const MAX_DIMENSION = 1600;
const WEBP_QUALITY = 0.8;

export async function processImage(file: File): Promise<Blob> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    const url = URL.createObjectURL(file);

    img.onload = () => {
      URL.revokeObjectURL(url);

      let { width, height } = img;
      if (width > MAX_DIMENSION || height > MAX_DIMENSION) {
        if (width > height) {
          height = Math.round((height * MAX_DIMENSION) / width);
          width = MAX_DIMENSION;
        } else {
          width = Math.round((width * MAX_DIMENSION) / height);
          height = MAX_DIMENSION;
        }
      }

      const canvas = document.createElement('canvas');
      canvas.width = width;
      canvas.height = height;

      const ctx = canvas.getContext('2d');
      if (!ctx) { reject(new Error('No canvas context')); return; }

      ctx.drawImage(img, 0, 0, width, height);
      canvas.toBlob(
        (blob) => blob ? resolve(blob) : reject(new Error('No blob')),
        'image/webp',
        WEBP_QUALITY,
      );
    };

    img.onerror = () => { URL.revokeObjectURL(url); reject(new Error('Error al cargar imagen')); };
    img.src = url;
  });
}

export function generateFileName(originalName: string): string {
  const timestamp = Date.now();
  const random = Math.random().toString(36).slice(2, 8);
  return `${timestamp}-${random}.webp`;
}
