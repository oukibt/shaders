using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
// [ImageEffectAllowedInSceneView]
public class VHSEffect : MonoBehaviour
{
	private Shader shader;
	private Material material;

	//

	public Color m_Color = Color.green;
	private Color m_last_Color;

	public Vector2 m_Grain = new Vector2(1.0f, 1.0f);
	private Vector2 m_last_Grain;

	[Range(0.0f, 1.0f)]
	public float m_Amount = 0.5f;
	private float m_last_Amount;

	[Range(0.0f, 1.0f)]
	public float m_Power = 1.0f;
	private float m_last_Power;

	[Range(0.0f, 20.0f)]
	public float m_Speed = 1.0f;
	private float m_last_Speed;

	public void Start()
	{
		m_last_Grain = m_Grain - Vector2.one;
		m_last_Amount = m_Amount - 1.0f;
		m_last_Power = m_Power - 1.0f;
		m_last_Speed = m_Speed - 1.0f;

		//

		shader = Shader.Find("Hidden/VHSEffect");
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
			if (m_Grain != m_last_Grain)
			{
				m_last_Grain = m_Grain;
				material.SetVector("_Grain", m_Grain);
			}

			if (m_Amount != m_last_Amount)
			{
				m_last_Amount = m_Amount;
				material.SetFloat("_Amount", m_Amount);
			}

			if (m_Power != m_last_Power)
			{
				m_last_Power = m_Power;
				material.SetFloat("_Power", m_Power);
			}

			if (m_Speed != m_last_Speed)
			{
				m_last_Speed = m_Speed;
				material.SetFloat("_Speed", m_Speed);
			}

			if (m_Color != m_last_Color)
			{
				m_last_Color = m_Color;
				material.SetColor("_Color", m_Color);
			}

			Graphics.Blit(inTexture, outTexture, material);
		}
		else
		{
			Graphics.Blit(inTexture, outTexture);
		}
	}
}
