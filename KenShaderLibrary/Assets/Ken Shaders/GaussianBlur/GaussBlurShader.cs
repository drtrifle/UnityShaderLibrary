using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GaussBlurShader : MonoBehaviour
{
    //material that's applied when doing postprocessing
    [SerializeField]
    private Material m_EffectMaterial;

    [Header("Blur Shader Values")]

    [Range(0, 10)]
    public int m_BlurAmount;
    public float[] m_KernelWeights;

    private const int m_KernelArrSize = 11;

    //Runs when inspector values changed
    void OnValidate() {
        CalculateKernelWeights();
    }

    //method which is automatically called by unity after the camera is done rendering
    void OnRenderImage(RenderTexture source, RenderTexture destination) {
        //draws the pixels from the source texture to the destination texture
        if (m_EffectMaterial != null) {
            Graphics.Blit(source, destination, m_EffectMaterial);
        }
    }

    void CalculateKernelWeights() {
        int totalWeight = 0;
        m_KernelWeights = new float[m_KernelArrSize];

        //Calculate total weights
        for(int i = 1; i <= m_BlurAmount; ++i) {
            m_KernelWeights[i] = (int)Mathf.Pow(2, m_BlurAmount - i);

            totalWeight += (int)Mathf.Pow(2, m_BlurAmount - i);
            totalWeight += (int)Mathf.Pow(2, m_BlurAmount - i);
        }

        m_KernelWeights[0] = (int)Mathf.Pow(2, m_BlurAmount);
        totalWeight += (int)Mathf.Pow(2, m_BlurAmount);

        //Calculate kernel weights
        for (int i = 0; i < m_KernelArrSize; ++i) {

            if(i <= m_BlurAmount)
                m_KernelWeights[i] = (m_KernelWeights[i] / totalWeight);
            else
                m_KernelWeights[i] = 0;
        }

        m_EffectMaterial.SetInt("_BlurAmount", m_BlurAmount);
        m_EffectMaterial.SetFloatArray("_KernelWeights", m_KernelWeights);
    }
}
