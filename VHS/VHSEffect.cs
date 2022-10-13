using UnityEngine;

// [ImageEffectAllowedInSceneView]
public class VHSEffect : MonoBehaviour
{
	private Shader shader;
	private Material material;

	private static readonly float NAN = -123456789.654321f;

	// TAPE NOISE

	public bool m_TapeNoise_Enabled = false;
	private bool old_m_TapeNoise_Enabled = false;

	public Color m_TapeNoise_Color = Color.yellow;
	private Color old_m_TapeNoise_Color = Color.green;

	public float m_TapeNoise_GrainSize = 0.2f;
	private float old_m_TapeNoise_GrainSize = NAN;

	public float m_TapeNoise_Amount = 0.8f;
	private float old_m_TapeNoise_Amount = NAN;

	public float m_TapeNoise_Power = 0.9f;
	private float old_m_TapeNoise_Power = NAN;

	public float m_TapeNoise_Speed = 5.0f;
	private float old_m_TapeNoise_Speed = NAN;

	// LINE NOISE

	public bool m_LineNoise_Enabled = false;
	public bool old_m_LineNoise_Enabled = false;

	public float m_LineNoise_Size = 0.05f;
	public float old_m_LineNoise_Size = NAN;

	public float m_LineNoise_Power = 2.0f;
	public float old_m_LineNoise_Power = NAN;

	public float m_LineNoise_XPower = 0.005f;
	public float old_m_LineNoise_XPower = NAN;

	public float m_LineNoise_Speed = 0.5f;
	public float m_LineNoise_Delay = 2.0f;
	private float m_LineNoise_Position = 0.0f;

	//

	public void Start()
	{
		shader = Shader.Find("Hidden/VHSEffect");
		material = new Material(shader);

		if (!SystemInfo.supportsImageEffects)
		{
			enabled = false;
			return;
		}

		if (shader == null || !shader.isSupported)
		{
			enabled = false;
		}
	}

	//

	public void OnRenderImage(RenderTexture inTexture, RenderTexture outTexture)
	{
		if (m_TapeNoise_Enabled != old_m_TapeNoise_Enabled)
		{
			old_m_TapeNoise_Enabled = m_TapeNoise_Enabled;

			if (m_TapeNoise_Enabled) material.EnableKeyword("_TAPE_NOISE_ON");
			else material.DisableKeyword("_TAPE_NOISE_ON");
		}

		if (m_LineNoise_Enabled != old_m_LineNoise_Enabled)
		{
			old_m_LineNoise_Enabled = m_LineNoise_Enabled;

			if (m_LineNoise_Enabled) material.EnableKeyword("_LINE_NOISE_ON");
			else material.DisableKeyword("_LINE_NOISE_ON");
		}

		// Speed, Amount, Color, Power, Grain
		// TAPE NOISE

		if (m_TapeNoise_Color != old_m_TapeNoise_Color)
		{
			old_m_TapeNoise_Color = m_TapeNoise_Color;
			material.SetColor("_TapeColor", m_TapeNoise_Color);
		}

		if (m_TapeNoise_GrainSize != old_m_TapeNoise_GrainSize)
		{
			old_m_TapeNoise_GrainSize = m_TapeNoise_GrainSize;
			material.SetFloat("_TapeGrainSize", m_TapeNoise_GrainSize * 20000.0f);
		}

		if (m_TapeNoise_Amount != old_m_TapeNoise_Amount)
		{
			old_m_TapeNoise_Amount = m_TapeNoise_Amount;
			material.SetFloat("_TapeAmount", m_TapeNoise_Amount);
		}

		if (m_TapeNoise_Power != old_m_TapeNoise_Power)
		{
			old_m_TapeNoise_Power = m_TapeNoise_Power;
			material.SetFloat("_TapePower", m_TapeNoise_Power);
		}

		if (m_TapeNoise_Speed != old_m_TapeNoise_Speed)
		{
			old_m_TapeNoise_Speed = m_TapeNoise_Speed;
			material.SetFloat("_TapeSpeed", m_TapeNoise_Speed);
		}

		// Size, Power, XPower, Position
		// LINE NOISE

		if (m_LineNoise_Size != old_m_LineNoise_Size)
		{
			old_m_LineNoise_Size = m_LineNoise_Size;
			material.SetFloat("_LineSize", m_LineNoise_Size);
		}

		if (m_LineNoise_Power != old_m_LineNoise_Power)
		{
			old_m_LineNoise_Power = m_LineNoise_Power;
			material.SetFloat("_LinePower", m_LineNoise_Power);
		}

		if (m_LineNoise_XPower != old_m_LineNoise_XPower)
		{
			old_m_LineNoise_XPower = m_LineNoise_XPower;
			material.SetFloat("_LineXPower", m_LineNoise_XPower);
		}

		m_LineNoise_Position = (float)(Time.unscaledTimeAsDouble * m_LineNoise_Speed % m_LineNoise_Delay);
		material.SetFloat("_LinePosition", m_LineNoise_Position);

		//

		Graphics.Blit(inTexture, outTexture, material);
	}
}
