using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
public class ChromaticAberration : MonoBehaviour
{
	private Shader shader;
	private Material material;

	public Vector2 m_offset = new Vector2();
	private Vector2 m_last_offset;

	//

	public bool m_fastMode = false;
	private bool m_last_fastMode;

	[Range(1, 64)]
	public int m_samples = 8;
	private int m_last_samples;

	//

	public bool m_useCenter = false;
	private bool m_last_useCenter;
	
	public Vector2 m_center = new Vector2();
	private Vector2 m_last_center = new Vector2();

	public void Start()
	{
		m_last_offset = m_offset - Vector2.one;
		m_fastMode = !m_fastMode;
		m_last_samples = m_samples - 1;
		m_last_useCenter = !m_useCenter;
		m_last_center = m_center - Vector2.one;

		//=

		shader = Shader.Find("Custom/ChromaticAberration");
		material = new Material(shader);

		if (!SystemInfo.supportsImageEffects)
		{
			enabled = false;
			return;
		}

		if (!shader && !shader.isSupported)
		{
			enabled = false;
		}
	}

	public void OnRenderImage(RenderTexture inTexture, RenderTexture outTexture)
	{
		if (shader != null)
		{
			if (m_fastMode != m_last_fastMode)
			{
				m_last_fastMode = m_fastMode;
				if (m_fastMode)
				{
					material.EnableKeyword("_FAST_MODE_ON");
				}
				else
				{
					material.DisableKeyword("_FAST_MODE_ON");
				}
			}

			if (m_samples != m_last_samples)
			{
				m_last_samples = m_samples;
				material.SetFloat("_Samples", m_samples);
			}

			//

			if (m_useCenter != m_last_useCenter)
			{
				m_last_useCenter = m_useCenter;
				if (m_useCenter)
				{
					material.EnableKeyword("_USE_CENTER_ON");
				}
				else
				{
					material.DisableKeyword("_USE_CENTER_ON");
				}
			}

			if (m_center != m_last_center)
			{
				m_last_center = m_center;
				material.SetVector("_Center", m_center);
			}

			//

			if (m_offset != m_last_offset)
			{
				m_last_offset = m_offset;
				material.SetVector("_Offset", m_offset * 0.05f);
			}

			Graphics.Blit(inTexture, outTexture, material);
		}
		else
		{
			Graphics.Blit(inTexture, outTexture);
		}
	}
}
